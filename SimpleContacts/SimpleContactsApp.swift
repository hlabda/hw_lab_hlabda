import SwiftUI
import SwiftData

@main
struct SimpleContactsApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
        .modelContainer(for: Person.self)
    }
}
