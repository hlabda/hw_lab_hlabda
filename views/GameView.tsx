import { useEffect, useRef, useState } from 'react';
import { AppState, Image, Platform, StyleSheet, Text, View } from 'react-native';
import type { LayoutChangeEvent } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { Accelerometer } from 'expo-sensors';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import { Constants } from '../models/Constants';
import GameStateManager from '../models/GameStateManager';
import type { Bullet } from '../models/Bullet';
import type { Invader } from '../models/Invader';
import { Wave } from '../viewModels/Wave';
import { initSound, playLaser, reportSoundError } from '../viewModels/sound';
import type { RootStackParamList } from '../types';

type Props = NativeStackScreenProps<RootStackParamList, 'Game'>;
const invaderImages = {
  1: require('../assets/images/invader1.png'),
  2: require('../assets/images/invader2.png'),
  3: require('../assets/images/invader3.png'),
};
const playerImages = { 1: require('../assets/images/player1.png'), 2: require('../assets/images/player2.png') };

/** Position a sprite or shot using the same geometry as collision detection. */
function position(entity: { x: number; y: number; width: number; height: number }) {
  return { left: entity.x, top: entity.y, width: entity.width, height: entity.height };
}

/** Draw one surviving invader with its assigned sprite. */
function drawInvader(invader: Invader) {
  return <Image key={invader.id} source={invaderImages[invader.imageType]} style={[styles.entity, position(invader)]} />;
}

/** Draw a laser in the firing side's color. */
function drawBullet(bullet: Bullet) {
  return <View key={bullet.id} style={[styles.entity, position(bullet), { backgroundColor: bullet.color }]} />;
}

/** Connect the measured playfield, tilt input, and two timers to the active wave. */
export default function GameView({ navigation }: Props) {
  const game = GameStateManager.instance;
  const insets = useSafeAreaInsets();
  const waveRef = useRef<Wave | null>(null);
  const tilt = useRef(0);
  const foreground = useRef(AppState.currentState !== 'background');
  const [, setFrame] = useState(0);
  const [motionHint, setMotionHint] = useState('');
  const wave = waveRef.current;

  /** Keep entity coordinates aligned with the visible playfield as safe-area insets settle. */
  function measure(event: LayoutChangeEvent) {
    const { width, height } = event.nativeEvent.layout;
    if (width <= 0 || height <= 0) return;
    if (waveRef.current) waveRef.current.resize(width, height);
    else {
      waveRef.current = new Wave(width, height);
      setFrame(1);
    }
  }

  // Subscribe to motion and foreground state for this screen's lifetime.
  useEffect(() => {
    let mounted = true;
    let sensor: ReturnType<typeof Accelerometer.addListener> | undefined;

    /** Request motion access, then listen only while this screen is mounted. */
    async function connectMotion() {
      if (!await Accelerometer.isAvailableAsync()) {
        if (mounted) setMotionHint('Tilt requires a motion sensor.');
        return;
      }
      const { granted } = await Accelerometer.requestPermissionsAsync();
      if (!mounted) return;
      if (!granted) {
        setMotionHint('Allow motion in Settings to steer.');
        return;
      }
      Accelerometer.setUpdateInterval(Constants.Input.accelerometerInterval);
      // Android reports acceleration against gravity. iOS reports the gravity component.
      sensor = Accelerometer.addListener(({ x }) => { tilt.current = Platform.OS === 'android' ? -x : x; });
    }
    // Keep the game running if the device cannot start its sensor.
    void connectMotion().catch(() => { if (mounted) setMotionHint('Tilt is unavailable on this device.'); });
    void initSound().catch(reportSoundError);
    // Suspend movement and firing while another app is in front.
    const activity = AppState.addEventListener('change', state => { foreground.current = state === 'active'; });

    // Release both subscriptions when the player leaves this wave.
    return () => {
      mounted = false;
      sensor?.remove();
      activity.remove();
    };
  }, []);

  // Run one movement timer and one enemy firing timer for this level.
  useEffect(() => {
    let frames = 0;

    /** Resolve a frame, then redraw or replace the current screen exactly once. */
    function update() {
      const active = waveRef.current;
      if (!active || !foreground.current || active.outcome !== 'playing') return;
      const outcome = active.update(tilt.current);
      if (outcome === 'levelComplete') navigation.replace('LevelComplete');
      else if (outcome === 'finished') {
        game.resetGame();
        navigation.popToTop();
      } else {
        setFrame(++frames);
      }
    }
    /** Let one eligible invader shoot while the app is visible. */
    function enemyShot() {
      if (foreground.current && waveRef.current?.fireInvader()) void playLaser().catch(reportSoundError);
    }
    const ticks = setInterval(update, 1000 / Constants.Game.fps);
    const shots = setInterval(enemyShot, Constants.Invader.fireInterval);
    // Clear both loops as soon as navigation unmounts this screen.
    return () => { clearInterval(ticks); clearInterval(shots); };
  }, [game, navigation]);

  /** Turn a playfield tap into a laser when the player can fire. */
  function tap() {
    if (foreground.current && waveRef.current?.firePlayer()) void playLaser().catch(reportSoundError);
  }

  return (
    <View style={styles.screen}>
      <View style={[StyleSheet.absoluteFill, insets]} onLayout={measure} onTouchStart={tap}>
        <View style={styles.hud}>
          <Text style={styles.label}>Score: {game.score}</Text>
          <Text style={styles.label}>Level: {game.currentLevel}</Text>
          <Text style={styles.label}>Lives: {game.lives}</Text>
        </View>
        {motionHint ? <Text style={styles.hint}>{motionHint}</Text> : null}
        {wave?.player.isAlive && <Image source={playerImages[wave.player.imageIndex]} style={[styles.entity, position(wave.player)]} />}
        {wave?.invaders.map(drawInvader)}
        {wave?.invaderBullets.map(drawBullet)}
        {wave?.playerBullets.map(drawBullet)}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: '#000' },
  hud: { flexDirection: 'row', justifyContent: 'space-around', paddingTop: 10 },
  label: { color: '#fff', fontSize: 16, fontWeight: 'bold' },
  hint: { color: '#bbb', fontSize: 12, textAlign: 'center', marginTop: 6 },
  entity: { position: 'absolute' },
});
