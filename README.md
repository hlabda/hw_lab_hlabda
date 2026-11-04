# EmojiHunter

EmojiHunter is a React Native camera game with five targets: laptop, phone, pen, book, and backpack. Each round gives you ten seconds. The game advances after a find or timeout and displays the total at the end.

## Run

1. Use Node.js 22.13+ or 24.3+ within those LTS releases and run `npm ci`.
2. Run `npm start` and open the project in Expo Go for SDK 58 on a phone.
3. Allow rear camera access. Use a network connection for MobileNet's initial download. The game processes frames on the device; it does not upload photos.
4. Point the camera at the target object. Select **Next emoji** after each result and **Play again** to restart.

MobileNet runs on TensorFlow.js's CPU backend so the game can run in Expo Go with standard Expo camera, image manipulation, and file modules. The countdown starts once the camera and model are both ready.

## Checks

- `npm test` checks the round transitions, scoring, replay, and label matching.
- `npm run typecheck` checks the TypeScript project.
