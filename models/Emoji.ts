export enum EmojiSearchStatus {
  Searching = 'Searching',
  Found = 'Found',
  NotFound = 'NotFound',
  GameOver = 'GameOver',
}

export interface Emoji {
  emoji: string;
  title: string;
  emojiNames: readonly string[];
}

// Only exact MobileNet synonyms count toward a match.
export const emojiObjects: readonly Emoji[] = [
  { emoji: '💻', title: 'Laptop', emojiNames: ['laptop', 'laptop computer', 'notebook', 'notebook computer'] },
  { emoji: '📱', title: 'Phone', emojiNames: ['cellular telephone', 'cellular phone', 'cellphone', 'cell', 'mobile phone'] },
  { emoji: '🖊️', title: 'Pen', emojiNames: ['ballpoint', 'ballpoint pen', 'ballpen', 'biro', 'fountain pen', 'quill pen'] },
  { emoji: '📕', title: 'Book', emojiNames: ['book jacket', 'dust cover', 'dust jacket', 'dust wrapper', 'comic book'] },
  { emoji: '🎒', title: 'Backpack', emojiNames: ['backpack', 'back pack', 'knapsack', 'packsack', 'rucksack', 'haversack'] },
];

type Prediction = { className: string; probability: number };

/** Checks the confident predictions for an exact, case-insensitive label match. */
export function matchesEmoji(predictions: readonly Prediction[], names: readonly string[]) {
  // Only consider labels above the confidence threshold.
  for (const { className, probability } of predictions) {
    if (probability <= 0.2) continue;
    for (const label of className.toLowerCase().split(',')) {
      if (names.includes(label.trim())) return true;
    }
  }
  return false;
}
