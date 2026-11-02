import Foundation
import CoreLocation
import Observation

/// Gets the device's location from Core Location and saves the car's coordinate to a plist.
@Observable
class LocationManager: NSObject {
  // MARK: - Observable Properties
  var coordinate = CarCoordinate()
  var authorizationStatus: CLAuthorizationStatus = .notDetermined
  var locationError: String?
  private(set) var isSavingLocation = false

  // MARK: - Private Properties
  @ObservationIgnored private let locationManager = CLLocationManager()
  @ObservationIgnored private let plistFileName = "Coordinates.plist"
  @ObservationIgnored private var locationSaveCompletion: (() -> Void)?
  @ObservationIgnored private var locationTimeout: Timer?

  // MARK: - Initialization

  /// Sets up the CLLocationManager and loads any previously saved car location.
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = kCLDistanceFilterNone
    authorizationStatus = locationManager.authorizationStatus
    loadLocation()
  }

  // MARK: - Public Methods

  // Requests location permissions and gets current location
  func saveCurrentLocation(completion: @escaping () -> Void = {}) {
    guard !isSavingLocation else { return }
    isSavingLocation = true
    // Clear any previous errors
    locationError = nil
    // Store completion handler to call after location is saved
    locationSaveCompletion = completion

    // Check authorization status
    switch authorizationStatus {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted, .denied:
      finishLocationRequest(error: "Location access denied. Enable location access for FindMyCar in Settings.")
    case .authorizedWhenInUse, .authorizedAlways:
      startLocationUpdates()
    @unknown default:
      finishLocationRequest(error: "Unable to check location permission. Please try again.")
    }
  }

  // Clears the saved car location
  func clearLocation() {
    coordinate = CarCoordinate()
    saveLocationToPlist()
  }

  // MARK: - Persistence Methods
  // This is such a small amount of data that we are just going to use
  // a plist-based persistence using Codable

  // Saves the current coordinate to a plist file using PropertyListEncoder
  private func saveLocationToPlist() {
    do {
      let encoder = PropertyListEncoder()
      encoder.outputFormat = .xml
      let data = try encoder.encode(coordinate)
      try data.write(to: plistURL(), options: .atomic)
    } catch {
      print("Error saving location: \(error.localizedDescription)")
      locationError = "Failed to save location"
    }
  }

  // Loads the coordinate from the plist file using PropertyListDecoder
  private func loadLocation() {
    let url = plistURL()
    guard FileManager.default.fileExists(atPath: url.path) else {
      return
    }
    do {
      let data = try Data(contentsOf: url)
      let decoder = PropertyListDecoder()
      coordinate = try decoder.decode(CarCoordinate.self, from: data)
    } catch {
      print("Error loading location: \(error.localizedDescription)")
    }
  }

  // MARK: - Private Helper Methods

  /// Starts position updates for a pending save and bounds the wait for a GPS fix.
  private func startLocationUpdates() {
    guard isSavingLocation else { return }
    locationTimeout?.invalidate()
    locationTimeout = Timer.scheduledTimer(withTimeInterval: 15, repeats: false) { [weak self] _ in
      #if targetEnvironment(simulator)
      self?.finishLocationRequest(error: "No simulated location is available. Run from Xcode with the CMU location selected, or set a custom simulator location, then try again.")
      #else
      self?.finishLocationRequest(error: "Unable to get your location. Check that Location Services are enabled in Settings, move to an open area, and try again.")
      #endif
    }
    locationManager.startUpdatingLocation()
  }

  /// Stops a save request and reports its result exactly once to the home screen.
  private func finishLocationRequest(error: String? = nil) {
    locationManager.stopUpdatingLocation()
    locationTimeout?.invalidate()
    locationTimeout = nil
    locationError = error
    isSavingLocation = false
    let completion = locationSaveCompletion
    locationSaveCompletion = nil
    completion?()
  }

  // Returns the URL for the plist file in the documents directory
  private func plistURL() -> URL {
    URL.documentsDirectory.appendingPathComponent(plistFileName)
  }
}

// MARK: - CLLocationManagerDelegate
// Delegate pattern: CLLocationManager reports location events back through these methods
extension LocationManager: CLLocationManagerDelegate {
  // Called when the user grants or changes location permission
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationStatus = manager.authorizationStatus
    // Only a user-requested save may change the parked location.
    guard isSavingLocation else { return }
    switch authorizationStatus {
    case .authorizedWhenInUse, .authorizedAlways:
      startLocationUpdates()
    case .denied, .restricted:
      finishLocationRequest(error: "Location access denied. Enable location access for FindMyCar in Settings.")
    case .notDetermined:
      break
    @unknown default:
      finishLocationRequest(error: "Unable to check location permission. Please try again.")
    }
  }

  // Called with new positions; saves the latest one as the car's location
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard isSavingLocation,
          let location = locations.last,
          location.horizontalAccuracy >= 0,
          CLLocationCoordinate2DIsValid(location.coordinate) else { return }
    // Update coordinate
    coordinate = CarCoordinate(
      latitude: location.coordinate.latitude,
      longitude: location.coordinate.longitude
    )
    // Save to plist
    saveLocationToPlist()
    finishLocationRequest(error: locationError)
  }

  // Called when Core Location cannot get a position; reports the error to the UI
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    guard isSavingLocation else { return }
    // A temporary missing GPS fix is retried until a position arrives or the timeout expires.
    if let locationError = error as? CLError {
      if locationError.code == .locationUnknown { return }
      if locationError.code == .denied {
        finishLocationRequest(error: "Location access denied. Enable Location Services and location access for FindMyCar in Settings.")
        return
      }
    }
    finishLocationRequest(error: "Failed to get location: \(error.localizedDescription)")
  }
}
