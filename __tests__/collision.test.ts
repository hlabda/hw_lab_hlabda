import { boundsOverlap } from '../viewModels/collision';

const box = { left: 0, right: 10, top: 0, bottom: 10 };

// Compare a rectangle with itself.
test('identical bounds overlap', () => {
  expect(boundsOverlap(box, box)).toBe(true);
});

// Separate the rectangles along each axis independently.
test('a gap on either axis prevents a collision', () => {
  expect(boundsOverlap(box, { ...box, left: 20, right: 30 })).toBe(false);
  expect(boundsOverlap(box, { ...box, top: 20, bottom: 30 })).toBe(false);
});

// Touching an edge contributes no shared area.
test('touching edges do not overlap', () => {
  expect(boundsOverlap(box, { ...box, left: 10, right: 20 })).toBe(false);
  expect(boundsOverlap(box, { ...box, top: 10, bottom: 20 })).toBe(false);
});

// Offset the second rectangle halfway across the first.
test('partial horizontal overlap counts', () => {
  expect(boundsOverlap(box, { ...box, left: 5, right: 15 })).toBe(true);
});

// Check a second rectangle enclosed by the first.
test('containment counts as overlap', () => {
  expect(boundsOverlap(box, { left: 2, right: 8, top: 2, bottom: 8 })).toBe(true);
});
