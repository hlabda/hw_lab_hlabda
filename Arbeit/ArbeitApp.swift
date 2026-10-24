import SwiftUI
import FirebaseCore

/// App delegate used only to set up Firebase when the app launches.
class AppDelegate: NSObject, UIApplicationDelegate {
  /// Called once at launch; configures Firebase from GoogleService-Info.plist.
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // Must run before any Firestore call, which is why it happens at launch.
    FirebaseApp.configure()
    return true
  }
}

/// The app's entry point.
@main
struct ArbeitApp: App {
  /// Connects the AppDelegate above to this SwiftUI app so its launch method runs.
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  /// The app's single window, which starts at AppView.
  var body: some Scene {
    WindowGroup {
      // Start with AppView, not generic ContentView
      AppView()
    }
  }
}
