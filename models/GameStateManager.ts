import { Constants } from './Constants';

export default class GameStateManager {
  private static shared: GameStateManager;
  private _currentLevel = 1;
  private _score = 0;
  private _lives: number = Constants.Player.startingLives;

  /** Restrict construction to the shared game session. */
  private constructor() {}

  /** Return the session shared by all three screens. */
  static get instance() {
    return this.shared ??= new GameStateManager();
  }

  /** Read the wave currently being played. */
  get currentLevel() { return this._currentLevel; }

  /** Read the points earned across cleared waves. */
  get score() { return this._score; }

  /** Read the number of ships still available. */
  get lives() { return this._lives; }

  /** Select the next wave while keeping the player's points and lives. */
  advanceToNextLevel() { this._currentLevel += 1; }

  /** Return the level counter to the opening wave. */
  resetLevel() { this._currentLevel = 1; }

  /** Check whether the final wave has already been cleared. */
  isMaxLevelReached() { return this.currentLevel > Constants.Game.maxLevels; }

  /** Award points for a successful hit. */
  addScore(points: number) { this._score += points; }

  /** Spend one life and return the remaining count. */
  loseLife() {
    this._lives = Math.max(0, this._lives - 1);
    return this._lives;
  }

  /** Restore the initial state for a new game. */
  resetGame() {
    this.resetLevel();
    this._score = 0;
    this._lives = Constants.Player.startingLives;
  }
}
