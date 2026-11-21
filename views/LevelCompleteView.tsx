import { Pressable, Text, View } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import GameStateManager from '../models/GameStateManager';
import type { RootStackParamList } from '../types';
import { menu } from './menuStyles';

/** Show the cleared level and the score and lives carried into the next wave. */
export default function LevelCompleteView({ navigation }: NativeStackScreenProps<RootStackParamList, 'LevelComplete'>) {
  const game = GameStateManager.instance;
  /** Replace this summary with a fresh playfield for the next wave. */
  function continueGame() { navigation.replace('Game'); }

  return (
    <View style={menu.container}>
      <Text style={menu.title}>LEVEL {game.currentLevel - 1}{'\n'}COMPLETE!</Text>
      <Text style={menu.stat}>Score: {game.score}</Text>
      <Text style={menu.stat}>Lives: {game.lives}</Text>
      <Pressable accessibilityRole="button" style={menu.button} onPress={continueGame}>
        <Text style={menu.buttonText}>NEXT LEVEL ({game.currentLevel})</Text>
      </Pressable>
    </View>
  );
}
