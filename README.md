# Lab 08: FindMyCar

**Platform: Swift (SwiftUI)**

An app that saves where you parked and shows the car on a map relative to your current location. Built with SwiftUI, MapKit, Core Location (`CLLocationManagerDelegate`), and a plist for persistence. Built and tested with **iPhone 17 Pro**.

## Run

1. Open `FindMyCar.xcodeproj` in Xcode.
2. Select the `FindMyCar` scheme and **iPhone 17 Pro** simulator, then press Command-R.
3. In the simulator, choose **Features > Location > Custom Location** (CMU: 40.444644, -79.945424).

Requires iOS 17 or later.

## Features

- **Here's My Car** asks for location permission, saves the current coordinate to `Coordinates.plist`, and shows an alert with the saved latitude and longitude.
- **Where's My Car?** (enabled once a location is saved) opens a map centered on the car with a custom car annotation, your own location, a coordinates card, and user-location, compass, and scale controls.
- The saved location is loaded again on the next launch.
- Location errors (denied permission, failures) are shown in an alert.

The code is organized into `Models/` (`CarLocation`, `CarCoordinate`, `LocationManager`) and `Views/` (`AppView`, `MapView`). `LocationManager` uses the `@Observable` macro. Every function and method is commented.

## Tests

Press Command-U in Xcode. `FindMyCarTests` contains seven Swift Testing tests for `CarCoordinate` (initializers, equality, plist round trip) and `LocationManager` (starting coordinate, clearing, denied permission).

`startsWithZeroCoordinate` clears any saved location first, because the test host shares the app's Documents folder and a location saved while running the app would otherwise be loaded.

Verified on iPhone 17 Pro with iOS 26.5: **7 tests passed, 0 failed**.
