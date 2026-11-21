import { Constants } from '../models/Constants';
import GameStateManager from '../models/GameStateManager';
import { Invader } from '../models/Invader';
import { InvaderBullet } from '../models/InvaderBullet';
import { PlayerBullet } from '../models/PlayerBullet';
import { Wave, seedInvaders } from '../viewModels/Wave';

const game = GameStateManager.instance;
// Start each gameplay scenario with its own score, fleet, and lives.
beforeEach(() => game.resetGame());

/** Place a projectile one frame away from hitting the player's ship. */
function hitShip(wave: Wave) {
  const ship = wave.player;
  wave.invaderBullets.push(new InvaderBullet(ship.x + ship.width / 2, ship.y - Constants.InvaderBullet.speed));
  wave.update(0);
}

// Check each wave's size and horizontal centering on a small phone.
test('three centered formations grow from 20 to 28 invaders', () => {
  for (let level = 1; level <= 3; level++) {
    const fleet = seedInvaders(level, 320);
    expect(fleet).toHaveLength((4 + level) * 4);
    expect(fleet[0].x).toBe(320 - fleet[fleet.length - 1].x - Constants.Invader.width);
  }
});

// Advance the real wave to verify tilt limits, cooldown and the two player sprites.
test('steering stops at the margins and repeated taps respect the cooldown', () => {
  const wave = new Wave(390, 780);
  expect(wave.firePlayer()).toBe(true);
  expect(wave.player.imageIndex).toBe(2);
  expect(wave.firePlayer()).toBe(false);
  for (let frame = 0; frame < 65; frame++) wave.update(1);
  expect(wave.player.x).toBe(390 - Constants.Layout.leftBound - wave.player.width);
  expect(wave.firePlayer()).toBe(true);
  expect(wave.player.imageIndex).toBe(1);
  for (let frame = 0; frame < 100; frame++) wave.update(-1);
  expect(wave.player.x).toBe(Constants.Layout.leftBound);
});

// Start at the wall to check a single drop followed by motion away from it.
test('the fleet drops and reverses together', () => {
  const wave = new Wave(390, 780);
  wave.invaders = [new Invader(0, 0, 340, 100), new Invader(1, 0, 340, 160)];
  wave.update(0);
  expect(wave.invaders[0].y).toBe(100 + Constants.Invader.dropDistance);
  expect(wave.invaders[1].y).toBe(160 + Constants.Invader.dropDistance);
  wave.update(0);
  expect(wave.invaders[0].x).toBeLessThan(340);
});

// Leave a hole at the bottom of a column and check which invader shoots.
test('enemy fire comes from the lowest surviving invader in a column', () => {
  const wave = new Wave(390, 780);
  wave.invaders = [new Invader(2, 1, 100, 200), new Invader(0, 1, 100, 80)];
  expect(wave.fireInvader()).toBe(true);
  expect(wave.invaderBullets[0].y).toBe(230);
});

// Two projectiles can meet the same target in a single tick.
test('a destroyed invader awards points and advances the wave only once', () => {
  const wave = new Wave(390, 780);
  wave.invaders = [new Invader(0, 0, 100, 100)];
  wave.playerBullets = [new PlayerBullet(115, 130), new PlayerBullet(115, 130)];
  expect(wave.update(0)).toBe('levelComplete');
  expect(wave.update(0)).toBe('levelComplete');
  expect([game.score, game.currentLevel, game.lives]).toEqual([10, 2, 3]);
});

// Hit the ship across all three lives, allowing its respawn delay between hits.
test('hits cost one life, block firing until respawn, and end the last life', () => {
  const wave = new Wave(390, 780);
  for (let lives = 2; lives >= 0; lives--) {
    hitShip(wave);
    expect(game.lives).toBe(lives);
    expect(wave.firePlayer()).toBe(false);
    if (lives > 0) {
      for (let frame = 0; frame < 59; frame++) wave.update(0);
      expect(wave.player.isAlive).toBe(false);
      for (let frame = 0; frame < 3; frame++) wave.update(0);
      expect(wave.player.isAlive).toBe(true);
    }
  }
  expect(wave.outcome).toBe('finished');
});

// Clear the final invader on each level through the normal collision path.
test('clearing the third level ends the run with a cumulative score', () => {
  for (let level = 1; level <= Constants.Game.maxLevels; level++) {
    const wave = new Wave(390, 780);
    wave.invaders = [new Invader(0, 0, 100, 100)];
    wave.playerBullets.push(new PlayerBullet(115, 130));
    expect(wave.update(0)).toBe(level < Constants.Game.maxLevels ? 'levelComplete' : 'finished');
  }
  expect(game.score).toBe(30);
});

// Android can report an initial size before its navigation-bar insets settle.
test('a late layout change keeps the ship clear of system bars and preserves the wave', () => {
  const wave = new Wave(390, 900);
  const fleet = wave.invaders;
  wave.firePlayer();
  wave.resize(390, 780);
  expect(wave.player.y + wave.player.height).toBe(780 - Constants.Player.bottomOffset);
  expect(wave.invaders).toBe(fleet);
  expect(wave.playerBullets).toHaveLength(1);
});
