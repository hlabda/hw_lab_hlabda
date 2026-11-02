import Testing
import CoreLocation
@testable import FindMyCar

/// Tests for saved coordinates and Core Location callback handling.
@Suite(.serialized)
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
    var completionCount = 0
    manager.saveCurrentLocation { completionCount += 1 }
    #expect(manager.locationError != nil)
    #expect(!manager.isSavingLocation)
    #expect(completionCount == 1)
  }

  /// Launch-time location callbacks must not overwrite a previously parked car.
  @Test func unsolicitedLocationDoesNotMoveParkedCar() {
    let manager = LocationManager()
    let parked = CarCoordinate(latitude: 40.444644, longitude: -79.945424)
    manager.coordinate = parked
    manager.locationManager(CLLocationManager(), didUpdateLocations: [
      CLLocation(latitude: 25.2854, longitude: 51.5310)
    ])
    #expect(manager.coordinate == parked)
  }

  /// A missing GPS fix at launch must not display an error before a save is requested.
  @Test func unsolicitedFailureDoesNotShowError() {
    let manager = LocationManager()
    manager.locationManager(CLLocationManager(), didFailWithError: CLError(.locationUnknown))
    #expect(manager.locationError == nil)
    #expect(!manager.isSavingLocation)
  }

  /// A temporary GPS failure keeps the request alive so a later position can be saved.
  @Test func temporaryFailureRecoversWithLocation() {
    let manager = LocationManager()
    defer { manager.clearLocation() }
    manager.authorizationStatus = .authorizedWhenInUse
    var completionCount = 0
    manager.saveCurrentLocation { completionCount += 1 }
    manager.locationManager(CLLocationManager(), didFailWithError: CLError(.locationUnknown))
    #expect(manager.locationError == nil)
    #expect(manager.isSavingLocation)
    #expect(completionCount == 0)

    manager.locationManager(CLLocationManager(), didUpdateLocations: [
      CLLocation(latitude: 40.444644, longitude: -79.945424)
    ])
    let parked = CarCoordinate(latitude: 40.444644, longitude: -79.945424)
    #expect(manager.coordinate == parked)
    #expect(LocationManager().coordinate == parked)
    #expect(!manager.isSavingLocation)
    #expect(completionCount == 1)
  }

  /// A terminal error ends the request once and preserves the previously parked location.
  @Test func terminalFailureCompletesOnce() {
    let manager = LocationManager()
    let parked = CarCoordinate(latitude: 40.444644, longitude: -79.945424)
    manager.coordinate = parked
    manager.authorizationStatus = .authorizedWhenInUse
    var completionCount = 0
    manager.saveCurrentLocation { completionCount += 1 }
    manager.locationManager(CLLocationManager(), didFailWithError: CLError(.denied))
    manager.locationManager(CLLocationManager(), didFailWithError: CLError(.denied))
    #expect(manager.locationError != nil)
    #expect(manager.coordinate == parked)
    #expect(!manager.isSavingLocation)
    #expect(completionCount == 1)
  }

  /// Repeated taps must not replace the first request's completion handler.
  @Test func duplicateSaveKeepsOriginalCompletion() {
    let manager = LocationManager()
    manager.authorizationStatus = .authorizedWhenInUse
    var firstCount = 0
    var secondCount = 0
    manager.saveCurrentLocation { firstCount += 1 }
    manager.saveCurrentLocation { secondCount += 1 }
    manager.locationManager(CLLocationManager(), didFailWithError: CLError(.denied))
    #expect(firstCount == 1)
    #expect(secondCount == 0)
  }
}
