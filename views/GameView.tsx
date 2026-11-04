import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { EmojiSearchStatus as Status, emojiObjects } from '../models/Emoji';
import { ROUND_DURATION } from '../viewModels/gameReducer';
import { useGameViewModel } from '../viewModels/useGameViewModel';
import CustomCamera from './CustomCamera';

/** Displays the hunt, the result of each round, and the final score. */
export default function GameView() {
  const game = useGameViewModel();
  const insets = useSafeAreaInsets();
  const target = emojiObjects[game.currentLevel];
  const total = emojiObjects.length;
  const searching = game.emojiStatus === Status.Searching;
  const gameOver = game.emojiStatus === Status.GameOver;
  const found = game.emojiStatus === Status.Found;
  const accent = found || gameOver ? '#D9FC88' : '#FFCB9D';

  return (
    <View style={styles.screen}>
      {searching && (
        <CustomCamera
          key={game.currentLevel}
          emojiNames={target.emojiNames}
          onEmojiFound={game.foundEmoji}
          onRoundReady={game.setRoundReady}
        />
      )}
      <View pointerEvents="none" style={[styles.header, { top: insets.top + 12 }]}>
        <Text style={styles.brand}>EMOJI HUNTER</Text>
        <Text style={styles.pill}>{gameOver ? 'COMPLETE' : `ROUND ${game.currentLevel + 1}/${total}`}</Text>
      </View>
      {searching ? (
        <View pointerEvents="none" style={[styles.target, { bottom: insets.bottom + 16 }]}>
          <View style={styles.targetRow}>
            <Text style={styles.emoji}>{target.emoji}</Text>
            <View style={styles.targetName}>
              <Text style={styles.kicker}>FIND THIS OBJECT</Text>
              <Text style={styles.object}>{target.title}</Text>
            </View>
            <Text style={[styles.time, game.timeRemaining <= 3 && { color: '#FFCB9D' }]}>
              {game.roundReady ? `${game.timeRemaining}s` : '—'}
            </Text>
          </View>
          <View style={styles.track}>
            <View style={[styles.progress, { width: `${game.timeRemaining / ROUND_DURATION * 100}%` }]} />
          </View>
        </View>
      ) : (
        <View style={[styles.result, { paddingTop: insets.top + 82, paddingBottom: insets.bottom + 22 }]}>
          <View style={styles.resultBody}>
            <View style={styles.badge}><Text style={styles.resultEmoji}>{gameOver ? '🏁' : target.emoji}</Text></View>
            <Text style={[styles.kicker, { color: accent }]}>{gameOver ? 'HUNT COMPLETE' : target.title.toUpperCase()}</Text>
            <Text style={styles.resultTitle}>{gameOver ? 'Game over' : found ? 'Found!' : 'Not found'}</Text>
            <Text style={styles.resultDetail}>
              {gameOver ? `You found ${game.score} of ${total} objects.` : found ? 'Nice find. Ready for the next target?' : 'Time ran out. Keep hunting!'}
            </Text>
          </View>
          <Pressable
            accessibilityRole="button"
            style={[styles.action, { backgroundColor: accent }]}
            onPress={gameOver ? game.restart : game.startNext}
          >
            <Text style={styles.actionText}>{gameOver ? 'Play again' : game.currentLevel + 1 === total ? 'See score' : 'Next emoji'}</Text>
          </Pressable>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: '#121710' },
  header: { zIndex: 1, position: 'absolute', left: 18, right: 18, flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', gap: 8 },
  brand: { color: '#F7FBEF', backgroundColor: '#171E15', borderRadius: 18, overflow: 'hidden', paddingHorizontal: 12, paddingVertical: 8, fontWeight: '900', fontSize: 13, letterSpacing: 1.7 },
  pill: { color: '#D9FC88', backgroundColor: '#232D1D', borderRadius: 18, overflow: 'hidden', paddingHorizontal: 10, paddingVertical: 8, fontSize: 11, fontWeight: '900', letterSpacing: 1.2 },
  target: { position: 'absolute', left: 16, right: 16, padding: 17, backgroundColor: '#182015', borderRadius: 24, borderWidth: 1, borderColor: '#394633', gap: 14 },
  targetRow: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  emoji: { fontSize: 36, textAlign: 'center', width: 55 },
  targetName: { flex: 1 },
  kicker: { color: '#D9FC88', fontSize: 11, fontWeight: '900', letterSpacing: 2 },
  object: { color: '#F7FBEF', fontSize: 25, fontWeight: '800' },
  time: { color: '#D9FC88', fontSize: 28, fontWeight: '900', fontVariant: ['tabular-nums'] },
  track: { height: 5, borderRadius: 5, backgroundColor: '#354431', overflow: 'hidden' },
  progress: { height: 5, backgroundColor: '#D9FC88', borderRadius: 5 },
  result: { flex: 1, paddingHorizontal: 20 },
  resultBody: { flex: 1, alignItems: 'center', justifyContent: 'center', gap: 12 },
  badge: { width: 126, height: 126, borderRadius: 44, backgroundColor: '#232D1D', borderWidth: 1, borderColor: '#394633', justifyContent: 'center', alignItems: 'center', marginBottom: 16 },
  resultEmoji: { fontSize: 62 },
  resultTitle: { color: '#F7FBEF', fontSize: 48, fontWeight: '900', textAlign: 'center' },
  resultDetail: { color: '#B8C6B0', fontSize: 16, lineHeight: 23, textAlign: 'center' },
  action: { minHeight: 56, borderRadius: 22, justifyContent: 'center', alignItems: 'center' },
  actionText: { color: '#1B2613', fontSize: 18, fontWeight: '900' },
});
