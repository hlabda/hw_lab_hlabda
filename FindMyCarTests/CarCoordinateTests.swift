import Testing
import Foundation
@testable import FindMyCar

/// Unit tests for the Codable CarCoordinate model.
struct CarCoordinateTests {
  /// The default initializer gives (0, 0).
  @Test func defaultInitializerIsZero() {
    let coord = CarCoordinate()
    #expect(coord.latitude == 0.0)
    #expect(coord.longitude == 0.0)
  }

  /// The custom initializer keeps the values passed in.
  @Test func customInitializerStoresValues() {
    let coord = CarCoordinate(latitude: 40.7128, longitude: -74.0060)
    #expect(coord.latitude == 40.7128)
    #expect(coord.longitude == -74.0060)
  }

  /// Coordinates with the same values are equal; different values are not.
  @Test func equalityWorks() {
    let a = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
    let b = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
    let c = CarCoordinate(latitude: 0, longitude: 0)
    #expect(a == b)
    #expect(a != c)
  }

  /// Encoding to a plist and decoding back gives the same coordinate.
  @Test func encodesAndDecodesRoundTrip() throws {
    let original = CarCoordinate(latitude: 40.4446, longitude: -79.9454)
    let data = try PropertyListEncoder().encode(original)
    let decoded = try PropertyListDecoder().decode(CarCoordinate.self, from: data)
    #expect(decoded == original)
  }
}
