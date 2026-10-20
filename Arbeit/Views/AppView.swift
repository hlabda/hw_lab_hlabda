import SwiftUI

/// The root view: owns the shared TasksViewModel and shows the Tasks and New Task tabs.
struct AppView: View {
  @State private var tasksViewModel = TasksViewModel()

  /// Builds the two tabs, each in its own navigation stack, and injects the view model into both.
  var body: some View {
    TabView {
      NavigationStack {
        TasksView()
      }
      .tabItem {
        Image(systemName: "checkmark.rectangle.stack.fill")
        Text("Tasks")
      }

      NavigationStack {
        NewTaskView()
      }
      .tabItem {
        Image(systemName: "plus.app.fill")
        Text("New Task")
      }
    }
    .environment(tasksViewModel)
  }
}
