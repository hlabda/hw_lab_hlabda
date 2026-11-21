export type Bounds = { left: number; right: number; top: number; bottom: number };

let nextBulletId = 0;
export class Bullet {
  readonly id = 'bullet_' + nextBulletId++;
  x: number;
  shouldRemove = false;

  /** Center the projectile on the firing entity's horizontal spawn point. */
  constructor(centerX: number, public y: number, readonly speed: number,
    readonly width: number, readonly height: number, readonly color: string) {
    this.x = centerX - width / 2;
  }

  /** Advance one frame along the firing direction. */
  update() { this.y += this.speed; }

  /** Check whether the entire shot has left the playfield. */
  isOffScreen(height: number) { return this.y + this.height <= 0 || this.y >= height; }

  /** Return the rectangle occupied by the projectile. */
  getBounds(): Bounds {
    return { left: this.x, right: this.x + this.width, top: this.y, bottom: this.y + this.height };
  }
}
