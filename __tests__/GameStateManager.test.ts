import GameStateManager from '../models/GameStateManager';
import { Constants } from '../models/Constants';

const game = GameStateManager.instance;
// Isolate each example from the previous singleton state.
beforeEach(() => game.resetGame());

// Check the score, level and lives for a new run.
test('starts at level one, with zero score and full lives', () => {
  expect([game.currentLevel, game.score, game.lives]).toEqual([1, 0, Constants.Player.startingLives]);
});

// Advance one wave without starting a new game.
test('advances to the next level', () => {
  game.advanceToNextLevel();
  expect(game.currentLevel).toBe(2);
});

// Reset only the level after advancing twice.
test('resets the level to one', () => {
  game.advanceToNextLevel();
  game.advanceToNextLevel();
  game.resetLevel();
  expect(game.currentLevel).toBe(1);
});

// Traverse every playable wave before checking the maximum.
test('exceeds the maximum only after clearing the last wave', () => {
  for (let level = 1; level <= Constants.Game.maxLevels; level++) {
    expect(game.isMaxLevelReached()).toBe(false);
    game.advanceToNextLevel();
  }
  expect(game.isMaxLevelReached()).toBe(true);
});

// Confirm that callers see the updated count immediately after a hit.
test('losing a life returns the decremented count', () => {
  expect(game.loseLife()).toBe(Constants.Player.startingLives - 1);
  expect(game.lives).toBe(Constants.Player.startingLives - 1);
});

// Award points in two separate events.
test('score accumulates', () => {
  game.addScore(10);
  game.addScore(25);
  expect(game.score).toBe(35);
});

// Change all session counters before restarting the game.
test('resetGame restores the complete starting state', () => {
  game.advanceToNextLevel();
  game.addScore(500);
  game.loseLife();
  game.resetGame();
  expect([game.currentLevel, game.score, game.lives]).toEqual([1, 0, Constants.Player.startingLives]);
});
