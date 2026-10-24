import SwiftUI

/// The main list of all tasks, with a + button to add one and swipe-to-delete.
struct TasksView: View {
  /// The shared view model, injected by AppView.
  @Environment(TasksViewModel.self) private var viewModel
  /// Whether the New Task sheet is open; the + button sets it to true.
  @State private var showingNewTask = false

  /// Builds the task list, the toolbar + button, the new-task sheet and the details navigation.
  var body: some View {
    List {
      // One row per task. Each task is wrapped in a TaskListRow so that
      // completing a task always redraws its row (see TaskListRow below).
      ForEach(viewModel.tasks.map(TaskListRow.init)) { row in
        // Tapping a row pushes its task; navigationDestination below shows the details screen.
        NavigationLink(value: row.task) {
          TaskRowView(task: row.task)
        }
      }
      // Enables swipe-left-to-delete on every row.
      .onDelete(perform: deleteTask)
    }
    .navigationTitle("Arbeit")
    .toolbar {
      // + button in the top-right corner that opens the New Task sheet.
      ToolbarItem(placement: .topBarTrailing) {
        Button(action: { showingNewTask = true }) {
          Image(systemName: "plus")
        }
      }
    }
    // The New Task form, shown as a sheet while showingNewTask is true.
    // The view model is passed in explicitly because sheets don't always inherit the environment.
    .sheet(isPresented: $showingNewTask) {
      NewTaskView()
        .environment(viewModel)
    }
    // Tells the navigation stack which screen to show when a TaskItem is pushed.
    .navigationDestination(for: TaskItem.self) { task in
      TaskDetailsView(task: task)
    }
  }

  /// Deletes the tasks at the rows the user swiped away.
  private func deleteTask(at offsets: IndexSet) {
    // offsets holds the positions of the swiped rows; look up each task and delete it.
    for index in offsets {
      viewModel.destroy(viewModel.tasks[index])
    }
  }
}

/// One entry in the task list. TaskItem's == ignores `completed`, so SwiftUI's list
/// would treat a task whose only change is `completed` as unchanged and not redraw it.
/// Storing `completed` here makes that change count, so the row updates.
private struct TaskListRow: Identifiable, Equatable {
  /// The task shown in this row.
  let task: TaskItem
  /// A copy of the task's completed flag, compared along with the task.
  let completed: Bool

  /// Wraps a task for display in the list.
  init(task: TaskItem) {
    self.task = task
    self.completed = task.completed
  }

  /// Uses the Firestore document ID, so each row keeps its identity across updates.
  var id: String? { task.id }
}
