import { EmojiSearchStatus as Status, emojiObjects } from '../models/Emoji';

export const ROUND_DURATION = 10;
export type GameState = {
  currentLevel: number;
  timeRemaining: number;
  emojiStatus: Status;
  showNext: boolean;
  score: number;
};
export const initialGameState: GameState = {
  currentLevel: 0,
  timeRemaining: ROUND_DURATION,
  emojiStatus: Status.Searching,
  showNext: false,
  score: 0,
};

export type GameAction =
  | { type: 'tick' }
  | { type: 'foundEmoji' }
  | { type: 'nextEmoji' }
  | { type: 'restart' };

/** Applies a timer, recognition, or navigation event to the current game. */
export function gameReducer(state: GameState, action: GameAction): GameState {
  switch (action.type) {
    case 'tick':
      if (state.emojiStatus !== Status.Searching) return state;
      if (state.timeRemaining > 1) return { ...state, timeRemaining: state.timeRemaining - 1 };
      return { ...state, timeRemaining: 0, emojiStatus: Status.NotFound, showNext: true };
    case 'foundEmoji':
      if (state.emojiStatus !== Status.Searching) return state;
      return { ...state, emojiStatus: Status.Found, showNext: true, score: state.score + 1 };
    case 'nextEmoji':
      if (state.emojiStatus !== Status.Found && state.emojiStatus !== Status.NotFound) return state;
      if (state.currentLevel === emojiObjects.length - 1) {
        return { ...state, emojiStatus: Status.GameOver, showNext: false };
      }
      return { ...initialGameState, currentLevel: state.currentLevel + 1, score: state.score };
    case 'restart':
      return initialGameState;
  }
}
