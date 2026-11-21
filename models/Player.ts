import { Constants } from './Constants';
import type { Bounds } from './Bullet';

export class Player {
  readonly width = Constants.Player.width;
  readonly height = Constants.Player.height;
  x = 0;
  y = 0;
  velocityX = 0;
  isAlive = true;
  imageIndex: 1 | 2 = 1;
  private lastFireTime = -Infinity;

  /** Position the ship for its first life. */
  constructor(private screenWidth: number, private screenHeight: number) {
    this.respawn();
  }

  /** Convert horizontal tilt into a capped distance per frame. */
  setVelocity(accelerationX: number) {
    const cap = Constants.Input.maxSpeed / Constants.Game.fps;
    this.velocityX = Math.max(-cap, Math.min(cap, accelerationX * Constants.Input.tiltSensitivity));
  }

  /** Move the ship without crossing the screen margins. */
  update() {
    const margin = Constants.Layout.leftBound;
    this.x = Math.max(margin, Math.min(this.screenWidth - this.width - margin, this.x + this.velocityX));
  }

  /** Reserve a shot if the ship is alive and its cooldown has expired. */
  canFire(now = Date.now()) {
    if (!this.isAlive || now - this.lastFireTime < Constants.Player.fireCooldown) return false;
    this.lastFireTime = now;
    return true;
  }

  /** Locate the ship's nose for a new laser. */
  getBulletSpawnPosition() { return { x: this.x + this.width / 2, y: this.y }; }

  /** Alternate the two ship sprites when firing. */
  toggleImage() { this.imageIndex = this.imageIndex === 1 ? 2 : 1; }

  /** Return the ship's collision rectangle. */
  getBounds(): Bounds {
    return { left: this.x, right: this.x + this.width, top: this.y, bottom: this.y + this.height };
  }

  /** Keep the current ship within the playfield when system insets or window size change. */
  resize(width: number, height: number) {
    this.x += (width - this.screenWidth) / 2;
    this.screenWidth = width;
    this.screenHeight = height;
    const margin = Constants.Layout.leftBound;
    this.x = Math.max(margin, Math.min(width - this.width - margin, this.x));
    this.y = height - this.height - Constants.Player.bottomOffset;
  }

  /** Hide the ship and disable firing after a hit. */
  kill() { this.isAlive = false; }

  /** Restore a stationary ship at the center of the starting line. */
  respawn() {
    this.x = (this.screenWidth - this.width) / 2;
    this.y = this.screenHeight - this.height - Constants.Player.bottomOffset;
    this.velocityX = 0;
    this.isAlive = true;
    this.imageIndex = 1;
  }
}
