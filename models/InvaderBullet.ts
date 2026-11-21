import { Bullet } from './Bullet';
import { Constants } from './Constants';

export class InvaderBullet extends Bullet {
  /** Launch a downward-moving red laser from an invader. */
  constructor(x: number, y: number) {
    const { speed, width, height, color } = Constants.InvaderBullet;
    super(x, y, speed, width, height, color);
  }
}
