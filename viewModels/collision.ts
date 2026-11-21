import type { Bounds } from '../models/Bullet';

type Collidable = { getBounds(): Bounds };
export type Collision<A, B> = { a: A; b: B };

/** Check for shared area, excluding rectangles that only touch at an edge. */
export function boundsOverlap(a: Bounds, b: Bounds) {
  return a.left < b.right && a.right > b.left && a.top < b.bottom && a.bottom > b.top;
}

/** Return each overlapping pair across two groups of entities. */
export function findCollisions<A extends Collidable, B extends Collidable>(as: A[], bs: B[]) {
  const hits: Collision<A, B>[] = [];
  for (const a of as) {
    const bounds = a.getBounds();
    for (const b of bs) {
      if (boundsOverlap(bounds, b.getBounds())) hits.push({ a, b });
    }
  }
  return hits;
}

/** Return the first object intersecting the target, or null if the path is clear. */
export function firstCollision<B extends Collidable>(target: Collidable, others: B[]): B | null {
  const bounds = target.getBounds();
  for (const other of others) {
    if (boundsOverlap(bounds, other.getBounds())) return other;
  }
  return null;
}
