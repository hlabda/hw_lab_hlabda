import { createAudioPlayer, setAudioModeAsync } from 'expo-audio';

let laser: ReturnType<typeof createAudioPlayer> | undefined;

/** Load the shared laser sample and allow effects while the ringer is muted. */
export async function initSound() {
  if (laser) return;
  await setAudioModeAsync({ playsInSilentMode: true, shouldPlayInBackground: false });
  laser ??= createAudioPlayer(require('../assets/sounds/laser.mp3'));
}

/** Replay the sample from the beginning whenever a ship fires. */
export async function playLaser() {
  if (!laser?.isLoaded) return;
  await laser.seekTo(0);
  laser.play();
}

/** Keep a native audio interruption from interrupting gameplay. */
export function reportSoundError(error: unknown) {
  console.warn('Laser audio unavailable', error);
}
