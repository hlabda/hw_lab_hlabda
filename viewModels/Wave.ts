import { Constants } from '../models/Constants';
import GameStateManager from '../models/GameStateManager';
import { Invader } from '../models/Invader';
import { InvaderBullet } from '../models/InvaderBullet';
import { Player } from '../models/Player';
import { PlayerBullet } from '../models/PlayerBullet';
import { findCollisions, firstCollision } from './collision';

export type Outcome = 'playing' | 'levelComplete' | 'finished';

/** Build a centered grid with one extra column for each successive level. */
export function seedInvaders(level: number, width: number) {
  const config = Constants.Invader;
  const columns = config.invadersPerLevelBase + level * config.invadersPerLevelMultiplier;
  const gridWidth = columns * config.width + (columns - 1) * config.horizontalSpacing;
  const left = (width - gridWidth) / 2;
  const invaders: Invader[] = [];
  for (let row = 0; row < config.rows; row++) {
    for (let col = 0; col < columns; col++) {
      invaders.push(new Invader(row, col, left + col * (config.width + config.horizontalSpacing),
        config.topOffset + row * config.verticalSpacing));
    }
  }
  return invaders;
}

export class Wave {
  readonly player: Player;
  invaders: Invader[];
  playerBullets: PlayerBullet[] = [];
  invaderBullets: InvaderBullet[] = [];
  outcome: Outcome = 'playing';
  private speed: number = Constants.Invader.initialSpeed;
  private elapsed = 0;
  private respawnAt = 0;

  /** Create the fleet and the player's ship for the current level. */
  constructor(private width: number, private height: number, private game = GameStateManager.instance) {
    this.player = new Player(width, height);
    this.invaders = seedInvaders(game.currentLevel, width);
  }

  /** Fire from the player's nose when a tap meets the cooldown. */
  firePlayer() {
    if (this.outcome !== 'playing' || !this.player.canFire(this.elapsed)) return false;
    const { x, y } = this.player.getBulletSpawnPosition();
    this.playerBullets.push(new PlayerBullet(x, y));
    this.player.toggleImage();
    return true;
  }

  /** Choose a column at random and fire from its lowest surviving invader. */
  fireInvader() {
    if (this.outcome !== 'playing' || !this.invaders.length) return false;
    const bottom = new Map<number, Invader>();
    for (const invader of this.invaders) {
      const previous = bottom.get(invader.column);
      if (!previous || previous.row < invader.row) bottom.set(invader.column, invader);
    }
    const shooters = Array.from(bottom.values());
    const { x, y } = shooters[Math.floor(Math.random() * shooters.length)].getBulletSpawnPosition();
    this.invaderBullets.push(new InvaderBullet(x, y));
    return true;
  }

  /** Advance the formation sideways, then step down and turn at either wall. */
  private march() {
    const left = Constants.Layout.leftBound;
    const right = this.width - left;
    let atWall = false;
    for (const invader of this.invaders) {
      invader.move(this.speed);
      if (invader.isAtEdge(left, right)) atWall = true;
    }
    if (atWall) {
      this.speed *= -1;
      for (const invader of this.invaders) invader.move(this.speed, Constants.Invader.dropDistance);
    }
  }

  /** Spend a life on impact and start the respawn delay if ships remain. */
  private hitPlayer() {
    this.player.kill();
    if (this.game.loseLife() === 0) this.outcome = 'finished';
    else this.respawnAt = this.elapsed + Constants.Player.respawnDelay;
  }

  /** Move all entities, resolve each hit once, and report when play should leave this screen. */
  update(tilt: number): Outcome {
    if (this.outcome !== 'playing') return this.outcome;
    this.elapsed += 1000 / Constants.Game.fps;
    if (!this.player.isAlive && this.elapsed >= this.respawnAt) this.player.respawn();
    if (this.player.isAlive) {
      this.player.setVelocity(tilt);
      this.player.update();
    }
    this.march();
    for (const bullet of this.playerBullets) bullet.update();
    for (const bullet of this.invaderBullets) bullet.update();

    for (const { a: shot, b: invader } of findCollisions(this.playerBullets, this.invaders)) {
      if (shot.shouldRemove || invader.shouldRemove) continue;
      shot.shouldRemove = invader.shouldRemove = true;
      this.game.addScore(Constants.Game.pointsPerInvader);
    }
    // Keep surviving invaders and player shots that are still in flight.
    this.invaders = this.invaders.filter(invader => !invader.shouldRemove);
    this.playerBullets = this.playerBullets.filter(shot => !shot.shouldRemove && !shot.isOffScreen(this.height));

    if (this.player.isAlive) {
      const hit = firstCollision(this.player, this.invaderBullets);
      if (hit) hit.shouldRemove = true;
      if (hit || firstCollision(this.player, this.invaders)) this.hitPlayer();
    }
    // Discard enemy shots after a hit or once they leave the playfield.
    this.invaderBullets = this.invaderBullets.filter(shot => !shot.shouldRemove && !shot.isOffScreen(this.height));
    if (this.outcome === 'playing' && !this.invaders.length) {
      this.game.advanceToNextLevel();
      this.outcome = this.game.isMaxLevelReached() ? 'finished' : 'levelComplete';
    }
    // End the run when any surviving invader reaches the bottom.
    if (this.invaders.some(invader => invader.y + invader.height >= this.height)) this.outcome = 'finished';
    return this.outcome;
  }
}
