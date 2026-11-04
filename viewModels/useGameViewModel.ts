import { useCallback, useEffect, useReducer, useState } from 'react';
import { EmojiSearchStatus } from '../models/Emoji';
import { gameReducer, initialGameState } from './gameReducer';

/** Runs the countdown while both the camera and the classifier are ready. */
export function useGameViewModel() {
  const [state, dispatch] = useReducer(gameReducer, initialGameState);
  const [roundReady, setRoundReady] = useState(false);

  useEffect(() => {
    if (!roundReady || state.emojiStatus !== EmojiSearchStatus.Searching) return;
    // Dispatch one tick per second, and cancel it when the round ends.
    const tick = () => dispatch({ type: 'tick' });
    const interval = setInterval(tick, 1000);
    return () => clearInterval(interval);
  }, [roundReady, state.emojiStatus]);

  // Resolve the current round after a confirmed match.
  const foundEmoji = useCallback(() => dispatch({ type: 'foundEmoji' }), []);
  // Reset readiness so the new round waits for its own camera preview.
  const startNext = () => {
    setRoundReady(false);
    dispatch({ type: 'nextEmoji' });
  };
  // Restore the first target and wait for the preview to reopen.
  const restart = () => {
    setRoundReady(false);
    dispatch({ type: 'restart' });
  };

  return { ...state, roundReady, setRoundReady, foundEmoji, startNext, restart };
}
