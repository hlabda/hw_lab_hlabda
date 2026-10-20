import SwiftUI

/// The main list of all tasks, with a + button to add one and swipe-to-delete.
struct TasksView: View {
  @Environment(TasksViewModel.self) private var viewModel
  @State private var showingNewTask = false

  /// Builds the task list, the toolbar + button, the new-task sheet and the details navigation.
  var body: some View {
    List {
      ForEach(viewModel.tasks.map(TaskListRow.init)) { row in
        NavigationLink(value: row.task) {
          TaskRowView(task: row.task)
        }
      }
      .onDelete(perform: deleteTask)
    }
    .navigationTitle("Arbeit")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(action: { showingNewTask = true }) {
          Image(systemName: "plus")
        }
      }
    }
    .sheet(isPresented: $showingNewTask) {
      NewTaskView()
        .environment(viewModel)
    }
    .navigationDestination(for: TaskItem.self) { task in
      TaskDetailsView(task: task)
    }
  }

  /// Deletes the tasks at the rows the user swiped away.
  private func deleteTask(at offsets: IndexSet) {
    for index in offsets {
      viewModel.destroy(viewModel.tasks[index])
    }
  }
}

/// One entry in the task list. TaskItem's == ignores `completed`, so SwiftUI's list
/// would treat a task whose only change is `completed` as unchanged and not redraw it.
/// Storing `completed` here makes that change count, so the row updates.
private struct TaskListRow: Identifiable, Equatable {
  let task: TaskItem
  let completed: Bool

  /// Wraps a task for display in the list.
  init(task: TaskItem) {
    self.task = task
    self.completed = task.completed
  }

  /// Uses the Firestore document ID, so each row keeps its identity across updates.
  var id: String? { task.id }
}
