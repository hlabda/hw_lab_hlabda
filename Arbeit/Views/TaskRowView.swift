import SwiftUI

/// One row in the task list showing the name, assignee, due date and a check mark when completed.
struct TaskRowView: View {
  let task: TaskItem
  /// Kept as its own property because TaskItem's == ignores `completed`. SwiftUI compares
  /// a view's properties to decide whether to redraw it, so without this the row would
  /// keep showing the old check mark after a task is completed or reopened.
  private let completed: Bool

  /// Creates a row for the given task.
  init(task: TaskItem) {
    self.task = task
    self.completed = task.completed
  }

  /// Lays out the task's details on the left and the completion check mark on the right.
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(task.name)
          .font(.headline)
          .strikethrough(completed)

        Text("Assigned to: \(task.assignedTo)")
          .font(.subheadline)
          .foregroundColor(.secondary)

        Text("Due: \(task.dueDate, style: .date)")
          .font(.caption)
          .foregroundColor(.secondary)
      }

      Spacer()

      if completed {
        Image(systemName: "checkmark.circle.fill")
          .foregroundColor(.green)
      }
    }
    .padding(.vertical, 4)
  }
}
