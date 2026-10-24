import SwiftUI

/// One row in the task list showing the name, assignee, due date and a check mark when completed.
struct TaskRowView: View {
  /// The task shown in this row.
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
      // Left side: the task's text, stacked top to bottom.
      VStack(alignment: .leading, spacing: 4) {
        // Task name, crossed out once the task is completed.
        Text(task.name)
          .font(.headline)
          .strikethrough(completed)

        // Who the task is assigned to, in smaller grey text.
        Text("Assigned to: \(task.assignedTo)")
          .font(.subheadline)
          .foregroundColor(.secondary)

        // Due date, formatted as a full date such as "28 October 2026".
        Text("Due: \(task.dueDate, style: .date)")
          .font(.caption)
          .foregroundColor(.secondary)
      }

      // Pushes the check mark to the right edge of the row.
      Spacer()

      // Right side: a green check mark, shown only for completed tasks.
      if completed {
        Image(systemName: "checkmark.circle.fill")
          .foregroundColor(.green)
      }
    }
    .padding(.vertical, 4)
  }
}
