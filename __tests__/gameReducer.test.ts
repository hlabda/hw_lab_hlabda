import { EmojiSearchStatus as Status, emojiObjects } from '../models/Emoji';
import { gameReducer, initialGameState, ROUND_DURATION } from '../viewModels/gameReducer';

describe('gameReducer', () => {
  // The first target is active with the complete time allowance.
  test('starts on the first target with ten seconds', () => {
    expect(initialGameState).toEqual({
      currentLevel: 0, timeRemaining: 10, emojiStatus: Status.Searching, showNext: false, score: 0,
    });
  });

  // An active round consumes one second on each tick.
  test('counts down during the hunt', () => {
    expect(gameReducer(initialGameState, { type: 'tick' }).timeRemaining).toBe(9);
  });

  // The last tick ends the round and makes the next target available.
  test('times out at zero', () => {
    const result = gameReducer({ ...initialGameState, timeRemaining: 1 }, { type: 'tick' });
    expect(result).toMatchObject({ timeRemaining: 0, emojiStatus: Status.NotFound, showNext: true });
  });

  // A successful match freezes the clock.
  test('ignores ticks after a find', () => {
    const found = gameReducer(initialGameState, { type: 'foundEmoji' });
    expect(gameReducer(found, { type: 'tick' })).toBe(found);
  });

  // A successful match scores one point and unlocks the next round.
  test('records a successful find', () => {
    expect(gameReducer(initialGameState, { type: 'foundEmoji' })).toMatchObject({
      emojiStatus: Status.Found, score: 1, showNext: true,
    });
  });

  // Predictions that return after the deadline cannot earn points.
  test('ignores a late prediction after timeout', () => {
    const expired = gameReducer({ ...initialGameState, timeRemaining: 1 }, { type: 'tick' });
    expect(gameReducer(expired, { type: 'foundEmoji' })).toBe(expired);
  });

  // The next target gets a fresh timer and the score carries over.
  test('advances a finished round', () => {
    const found = gameReducer(initialGameState, { type: 'foundEmoji' });
    expect(gameReducer(found, { type: 'nextEmoji' })).toMatchObject({
      currentLevel: 1, timeRemaining: ROUND_DURATION, emojiStatus: Status.Searching, showNext: false, score: 1,
    });
  });

  // Advancing from the last result leads to the final score.
  test('ends the game after the final round', () => {
    const finalRound = { ...initialGameState, currentLevel: emojiObjects.length - 1 };
    const found = gameReducer(finalRound, { type: 'foundEmoji' });
    expect(gameReducer(found, { type: 'nextEmoji' })).toMatchObject({
      emojiStatus: Status.GameOver, score: 1, showNext: false,
    });
  });

  // Replay resets the target, time, and score.
  test('resets the game when replayed', () => {
    const ended = { ...initialGameState, currentLevel: 4, emojiStatus: Status.GameOver, score: 3 };
    expect(gameReducer(ended, { type: 'restart' })).toEqual(initialGameState);
  });
});
