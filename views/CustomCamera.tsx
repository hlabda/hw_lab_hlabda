import { useEffect, useRef, useState } from 'react';
import { ActivityIndicator, Linking, Pressable, StyleSheet, Text, View } from 'react-native';
import { CameraView, useCameraPermissions } from 'expo-camera';
import { ImageManipulator, SaveFormat } from 'expo-image-manipulator';
import { File } from 'expo-file-system';
import * as tf from '@tensorflow/tfjs';
import * as mobilenet from '@tensorflow-models/mobilenet';
import jpeg from 'jpeg-js';
import { matchesEmoji } from '../models/Emoji';

let modelPromise: Promise<mobilenet.MobileNet> | undefined;

/** Loads the model once and runs inference locally using TensorFlow's CPU backend. */
async function loadClassifier() {
  if (!modelPromise) {
    modelPromise = initializeClassifier();
  }
  try {
    return await modelPromise;
  } catch (error) {
    modelPromise = undefined;
    throw error;
  }
}

/** Initializes and warms up MobileNet before starting the first timer. */
async function initializeClassifier() {
  // Hermes is neither a browser nor Node, so register its runtime primitives.
  const environment = tf.env();
  if (!environment.platform) {
    environment.setPlatform('react-native', {
      fetch: (path, init) => globalThis.fetch(path, init),
      now: () => performance.now(),
      encode: (value) => new TextEncoder().encode(value),
      decode: (bytes, encoding) => new TextDecoder(encoding).decode(bytes),
      isTypedArray: (value): value is Float32Array | Int32Array | Uint8Array | Uint8ClampedArray =>
        value instanceof Float32Array || value instanceof Int32Array ||
        value instanceof Uint8Array || value instanceof Uint8ClampedArray,
    });
  }
  await tf.setBackend('cpu');
  await tf.ready();
  return mobilenet.load({ version: 1, alpha: 0.5 });
}

/** Captures a frame in memory and converts its resized JPEG to an RGB tensor. */
async function captureTensor(camera: CameraView) {
  const picture = await camera.takePictureAsync({ pictureRef: true, shutterSound: false });
  const context = ImageManipulator.manipulate(picture);
  // Keep object proportions by cropping the middle of the frame before resizing.
  const side = Math.min(picture.width, picture.height);
  context.crop({
    originX: Math.floor((picture.width - side) / 2),
    originY: Math.floor((picture.height - side) / 2),
    width: side,
    height: side,
  });
  context.resize({ width: 224, height: 224 });
  const resized = await context.renderAsync();
  const saved = await resized.saveAsync({ format: SaveFormat.JPEG });
  const file = new File(saved.uri);
  try {
    const { width, height, data } = jpeg.decode(await file.bytes(), { useTArray: true });
    const rgb = new Int32Array(width * height * 3);
    for (let source = 0, dest = 0; source < data.length; source += 4) {
      rgb[dest++] = data[source];
      rgb[dest++] = data[source + 1];
      rgb[dest++] = data[source + 2];
    }
    return tf.tensor3d(rgb, [height, width, 3], 'int32');
  } finally {
    file.delete();
  }
}

type Props = {
  emojiNames: readonly string[];
  onEmojiFound: () => void;
  onRoundReady: (ready: boolean) => void;
};

/** Shows the rear camera and samples one frame at a time until the round ends. */
export default function CustomCamera({ emojiNames, onEmojiFound, onRoundReady }: Props) {
  const [permission, requestPermission] = useCameraPermissions();
  const camera = useRef<CameraView>(null);
  const [cameraReady, setCameraReady] = useState(false);
  const [model, setModel] = useState<mobilenet.MobileNet>();
  const [error, setError] = useState('');
  const [attempt, setAttempt] = useState(0);
  const granted = permission?.granted === true;

  useEffect(() => {
    if (!granted) return;
    let active = true;
    // Ignore load results after the camera leaves the screen.
    async function prepareModel() {
      try {
        const classifier = await loadClassifier();
        if (active) setModel(classifier);
      } catch (err) {
        console.warn('MobileNet failed to load:', err);
        if (active) setError('Could not load MobileNet. Check your connection and retry.');
      }
    }
    void prepareModel();
    return () => { active = false; };
  }, [granted, attempt]);

  useEffect(() => {
    const ready = granted && cameraReady && !!model && !error;
    onRoundReady(ready);
    if (!ready || !model) return;

    let active = true;
    let processing = false;
    let found = false;
    const classifier = model;

    // Skip overlapping captures and discard predictions from rounds that ended.
    async function classifyFrame() {
      if (!active || !camera.current || processing || found) return;
      processing = true;
      let frame: tf.Tensor3D | undefined;
      try {
        frame = await captureTensor(camera.current);
        if (!active) return;
        const predictions = await classifier.classify(frame);
        if (__DEV__) console.log('MobileNet:', predictions);
        if (active && matchesEmoji(predictions, emojiNames)) {
          found = true;
          onEmojiFound();
        }
      } catch (err) {
        if (active) {
          console.warn('Could not classify a camera frame:', err);
          setError('Could not read the camera. Try opening it again.');
        }
      } finally {
        frame?.dispose();
        processing = false;
      }
    }

    const interval = setInterval(classifyFrame, 1000);
    return () => {
      active = false;
      clearInterval(interval);
    };
  }, [cameraReady, emojiNames, error, granted, model, onEmojiFound, onRoundReady]);

  // Opens the OS camera prompt or settings if the prompt cannot be shown again.
  const allowCamera = () => {
    if (permission?.canAskAgain) void requestPermission();
    else void Linking.openSettings();
  };
  // Marks the preview ready so the countdown can begin.
  const markCameraReady = () => setCameraReady(true);
  // Pauses the game when the native camera cannot mount.
  const reportCameraError = () => setError('Could not open the rear camera.');
  // Reopens the preview and retries loading if the model did not initialize.
  const retry = () => {
    setCameraReady(false);
    setError('');
    setAttempt((value) => value + 1);
  };

  if (!permission) return <ActivityIndicator style={styles.feedback} color="#D9FC88" />;
  if (!granted) {
    return (
      <View style={styles.feedback}>
        <Text style={styles.title}>Camera access</Text>
        <Text style={styles.body}>Use your rear camera to find objects around you.</Text>
        <Pressable style={styles.button} onPress={allowCamera} accessibilityRole="button">
          <Text style={styles.buttonText}>{permission.canAskAgain ? 'Enable camera' : 'Open settings'}</Text>
        </Pressable>
      </View>
    );
  }

  return (
    <View style={StyleSheet.absoluteFill}>
      {!error && (
        <CameraView
          ref={camera}
          style={StyleSheet.absoluteFill}
          facing="back"
          animateShutter={false}
          onCameraReady={markCameraReady}
          onMountError={reportCameraError}
        />
      )}
      {(error || !model || !cameraReady) && (
        <View style={styles.feedback}>
          {!error && <ActivityIndicator color="#D9FC88" />}
          <Text style={styles.body}>{error || (!model ? 'Loading MobileNet…' : 'Opening camera…')}</Text>
          {!!error && (
            <Pressable style={styles.button} onPress={retry} accessibilityRole="button">
              <Text style={styles.buttonText}>Try again</Text>
            </Pressable>
          )}
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  feedback: { ...StyleSheet.absoluteFill, backgroundColor: '#121710', alignItems: 'center', justifyContent: 'center', paddingHorizontal: 32, gap: 12 },
  title: { color: '#FFF', fontSize: 27, fontWeight: '800' },
  body: { color: '#D3DECC', textAlign: 'center', fontSize: 16, lineHeight: 22 },
  button: { backgroundColor: '#D9FC88', paddingVertical: 12, paddingHorizontal: 22, borderRadius: 20, marginTop: 4 },
  buttonText: { color: '#1D2A0C', fontSize: 15, fontWeight: '800' },
});
