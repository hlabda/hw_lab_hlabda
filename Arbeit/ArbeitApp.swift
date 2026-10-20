import SwiftUI
import FirebaseCore

/// App delegate used only to set up Firebase when the app launches.
class AppDelegate: NSObject, UIApplicationDelegate {
  /// Called once at launch; configures Firebase from GoogleService-Info.plist.
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

/// The app's entry point.
@main
struct ArbeitApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  /// The app's single window, which starts at AppView.
  var body: some Scene {
    WindowGroup {
      // Start with AppView, not generic ContentView
      AppView()
    }
  }
}
