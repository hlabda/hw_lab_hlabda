import Testing
import CoreLocation
@testable import FindMyCar

/// Unit tests for LocationManager's state handling (not the Core Location callbacks).
@MainActor
struct LocationManagerTests {
  /// A new manager with nothing saved starts at (0, 0).
  @Test func startsWithZeroCoordinate() {
    let manager = LocationManager()
    manager.clearLocation()
    let fresh = LocationManager()
    #expect(fresh.coordinate == CarCoordinate())
  }

  /// clearLocation resets the coordinate to (0, 0).
  @Test func clearLocationResetsCoordinate() {
    let manager = LocationManager()
    manager.coordinate = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
    manager.clearLocation()
    #expect(manager.coordinate == CarCoordinate())
  }

  /// Saving with denied permission sets an error message.
  @Test func deniedAuthorizationProducesError() {
    let manager = LocationManager()
    manager.authorizationStatus = .denied
    manager.saveCurrentLocation()
    #expect(manager.locationError != nil)
  }
}
