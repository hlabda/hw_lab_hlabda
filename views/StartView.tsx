import { Pressable, Text, View } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import GameStateManager from '../models/GameStateManager';
import type { RootStackParamList } from '../types';
import { menu } from './menuStyles';

/** Show the arcade title, controls, and entry point for a fresh run. */
export default function StartView({ navigation }: NativeStackScreenProps<RootStackParamList, 'Start'>) {
  /** Restore the opening wave, score, and lives before entering the playfield. */
  function start() {
    GameStateManager.instance.resetGame();
    navigation.navigate('Game');
  }
  return (
    <View style={menu.container}>
      <Text style={menu.title}>{'SPACE\nDESTROYERS'}</Text>
      <Pressable accessibilityRole="button" style={menu.button} onPress={start}>
        <Text style={menu.buttonText}>START GAME</Text>
      </Pressable>
      <Text style={menu.hint}>Tilt to move · Tap to fire</Text>
    </View>
  );
}
