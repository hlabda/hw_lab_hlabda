import { Bullet } from './Bullet';
import { Constants } from './Constants';

export class PlayerBullet extends Bullet {
  /** Launch an upward-moving green laser from the ship's nose. */
  constructor(x: number, y: number) {
    const { speed, width, height, color } = Constants.Player.bullet;
    super(x, y - height, -speed, width, height, color);
  }
}
