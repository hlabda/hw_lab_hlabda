import Foundation
import CoreLocation

// Helper struct to make the car location identifiable for Map annotations
struct CarLocation: Identifiable {
  /// Unique ID so SwiftUI's Map can tell annotations apart.
  let id = UUID()
  /// Where the car is on the map.
  let coordinate: CLLocationCoordinate2D
  /// Main label for the annotation.
  let title: String
  /// Extra detail shown under the title.
  let subtitle: String
}
