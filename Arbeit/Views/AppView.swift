import SwiftUI

/// The root view: owns the shared TasksViewModel and shows the Tasks and New Task tabs.
struct AppView: View {
  /// The one view model for the whole app. @State keeps the same instance
  /// alive while the app runs, instead of creating a new one on every redraw.
  @State private var tasksViewModel = TasksViewModel()

  /// Builds the two tabs, each in its own navigation stack, and injects the view model into both.
  var body: some View {
    TabView {
      // First tab: the task list. Its own NavigationStack lets it push the details screen.
      NavigationStack {
        TasksView()
      }
      .tabItem {
        Image(systemName: "checkmark.rectangle.stack.fill")
        Text("Tasks")
      }

      // Second tab: the New Task form, with its own title bar.
      NavigationStack {
        NewTaskView()
      }
      .tabItem {
        Image(systemName: "plus.app.fill")
        Text("New Task")
      }
    }
    // Makes the view model available to every view inside both tabs.
    .environment(tasksViewModel)
  }
}
