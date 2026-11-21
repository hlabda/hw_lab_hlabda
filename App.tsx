import { DarkTheme, NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { StatusBar } from 'expo-status-bar';
import type { RootStackParamList } from './types';
import StartView from './views/StartView';
import GameView from './views/GameView';
import LevelCompleteView from './views/LevelCompleteView';

const Stack = createNativeStackNavigator<RootStackParamList>();

/** Open the start menu and connect it to gameplay and the between-level screen. */
export default function App() {
  return (
    <SafeAreaProvider>
      <StatusBar style="light" />
      <NavigationContainer theme={DarkTheme}>
        <Stack.Navigator initialRouteName="Start" screenOptions={{ headerShown: false }}>
          <Stack.Screen name="Start" component={StartView} />
          <Stack.Screen name="Game" component={GameView} />
          <Stack.Screen name="LevelComplete" component={LevelCompleteView} />
        </Stack.Navigator>
      </NavigationContainer>
    </SafeAreaProvider>
  );
}
