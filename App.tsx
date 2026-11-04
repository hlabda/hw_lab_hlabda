import { StatusBar } from 'expo-status-bar';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import GameView from './views/GameView';

/** Provides safe-area measurements and opens the EmojiHunter game. */
export default function App() {
  return (
    <SafeAreaProvider>
      <StatusBar style="light" />
      <GameView />
    </SafeAreaProvider>
  );
}
