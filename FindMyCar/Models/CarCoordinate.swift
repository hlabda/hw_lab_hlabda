import Foundation

// Codable struct for plist persistence
struct CarCoordinate: Codable, Equatable {
  /// North/south position in degrees.
  var latitude: Double
  /// East/west position in degrees.
  var longitude: Double

  /// Creates a coordinate; defaults to (0, 0), which the app treats as "no location saved".
  init(latitude: Double = 0.0, longitude: Double = 0.0) {
    self.latitude = latitude
    self.longitude = longitude
  }
}
