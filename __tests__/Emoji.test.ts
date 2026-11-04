import { emojiObjects, matchesEmoji } from '../models/Emoji';

describe('matchesEmoji', () => {
  // The classifier returns several comma-separated synonyms for each class.
  test('accepts an exact synonym after trimming and normalizing case', () => {
    expect(matchesEmoji([{ className: 'other, Laptop Computer ', probability: 0.7 }], emojiObjects[0].emojiNames)).toBe(true);
  });

  // Similar words and low confidence should not cause a false find.
  test('rejects substrings and low confidence matches', () => {
    expect(matchesEmoji([
      { className: 'king penguin', probability: 0.9 },
      { className: 'ballpoint pen', probability: 0.2 },
    ], emojiObjects[2].emojiNames)).toBe(false);
  });
});
