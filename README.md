# Lab 08: FindMyCar

**Platform: Swift (SwiftUI)**

An app that saves where you parked and shows the car on a map relative to your current location. Built with SwiftUI, MapKit, Core Location (`CLLocationManagerDelegate`), and a plist for persistence. Built and tested with **iPhone 17 Pro**.

## Run

1. Open `FindMyCar.xcodeproj` in Xcode.
2. Select the `FindMyCar` scheme and **iPhone 17 Pro** simulator, then press Command-R.
3. Tap **Here's My Car** and allow location access. The shared Run scheme selects `CMU.gpx` as its sample GPS location (40.444644, -79.945424).
4. Dismiss the saved-location alert, then tap **Where's My Car?** to see the car on the map.

The CMU sample is an Xcode debugging setting. To use a real iPhone's GPS while running from Xcode, select **Don't Simulate Location** in Xcode's location menu.

If launching directly in the simulator rather than through Xcode, set a sample location using the simulator's location controls. A simulator without a sample location cannot provide GPS coordinates. Temporary missing-location errors are retried for up to 15 seconds; if no position arrives, the app shows instructions and lets you retry.

Requires iOS 17 or later.

## Features

- **Here's My Car** asks for location permission, saves the current coordinate to `Coordinates.plist`, and shows an alert with the saved latitude and longitude.
- **Where's My Car?** (enabled once a location is saved) opens a map centered on the car with a custom car annotation, your own location, a coordinates card, and user-location, compass, and scale controls.
- The saved location is loaded again on the next launch and changes only when **Here's My Car** is tapped.
- **Getting Location…** is shown while waiting for GPS, with repeated saves disabled.
- Location errors (denied permission, failures) are shown in an alert.

The code is organized into `Models/` (`CarLocation`, `CarCoordinate`, `LocationManager`) and `Views/` (`AppView`, `MapView`). `LocationManager` uses the `@Observable` macro. Every function and method is commented.

## Tests

Press Command-U in Xcode. `FindMyCarTests` contains twelve Swift Testing tests for `CarCoordinate` (initializers, equality, plist round trip) and `LocationManager` (starting coordinate, clearing, denied permission, transient GPS failure recovery, persistence, unsolicited callbacks, and repeated saves).

`startsWithZeroCoordinate` clears any saved location first, because the test host shares the app's Documents folder and a location saved while running the app would otherwise be loaded.

Verified on iPhone 17 Pro with iOS 26.5: **12 tests passed, 0 failed**.
