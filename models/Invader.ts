import { Constants } from './Constants';
import type { Bounds } from './Bullet';

export class Invader {
  readonly id: string;
  readonly width = Constants.Invader.width;
  readonly height = Constants.Invader.height;
  readonly imageType: 1 | 2 | 3;
  shouldRemove = false;

  /** Place one invader in the formation and choose its sprite. */
  constructor(readonly row: number, readonly column: number, public x: number, public y: number) {
    this.id = 'invader_' + row + '_' + column;
    const [min, max] = Constants.Invader.imageTypeRange;
    this.imageType = (min + Math.floor(Math.random() * (max - min + 1))) as 1 | 2 | 3;
  }

  /** Translate the invader with the rest of the formation. */
  move(dx: number, dy = 0) {
    this.x += dx;
    this.y += dy;
  }

  /** Check whether either side has crossed the playable margin. */
  isAtEdge(left: number, right: number) { return this.x < left || this.x + this.width > right; }

  /** Locate the muzzle at the center of the lower edge. */
  getBulletSpawnPosition() { return { x: this.x + this.width / 2, y: this.y + this.height }; }

  /** Return the invader's collision rectangle. */
  getBounds(): Bounds {
    return { left: this.x, right: this.x + this.width, top: this.y, bottom: this.y + this.height };
  }
}
