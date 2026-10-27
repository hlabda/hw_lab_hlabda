import SwiftUI

/// The app's entry point.
@main
struct FindMyCarApp: App {
  /// The app's single window, which starts at AppView.
  var body: some Scene {
    WindowGroup {
      // Start with AppView, not generic ContentView
      AppView()
    }
  }
}
