import SwiftUI

/// Shows one task so it can be edited, marked completed or deleted.
struct TaskDetailsView: View {
  /// The task as it was when this screen opened.
  let task: TaskItem
  /// The shared view model, used to save or delete the task.
  @Environment(TasksViewModel.self) private var viewModel
  /// Goes back to the task list.
  @Environment(\.dismiss) private var dismiss

  // Editable copies of the task's fields. Changes stay here until Save is tapped,
  // so backing out without saving leaves the task unchanged.
  @State private var name: String
  @State private var assignedTo: String
  @State private var dueDate: Date
  @State private var completed: Bool
  /// Whether the validation alert is showing.
  @State private var showingAlert = false
  /// Whether the "Are you sure?" delete dialog is showing.
  @State private var showingDeleteConfirmation = false

  /// Fills the editable fields with the task's current values.
  init(task: TaskItem) {
    self.task = task
    // The _ prefix sets each @State's starting value from the task passed in.
    _name = State(initialValue: task.name)
    _assignedTo = State(initialValue: task.assignedTo)
    _dueDate = State(initialValue: task.dueDate)
    _completed = State(initialValue: task.completed)
  }

  /// Builds the edit form, the date-added metadata, the delete button, and the alert and confirmation dialog.
  var body: some View {
    Form {
      // Fields the user can edit.
      Section(header: Text("Task Details")) {
        TextField("Task Name", text: $name)
        TextField("Assigned To", text: $assignedTo)
        DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
        Toggle("Completed", isOn: $completed)
      }

      // Read-only information that can't be edited.
      Section(header: Text("Metadata")) {
        HStack {
          Text("Date Added")
          Spacer()
          Text(task.dateAdded, style: .date)
            .foregroundColor(.secondary)
        }
      }

      // A red delete button; it asks for confirmation before deleting anything.
      Section {
        Button("Delete Task", role: .destructive) {
          showingDeleteConfirmation = true
        }
      }
    }
    .navigationTitle("Task Details")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      // Save in the top-right corner validates and saves the edits.
      ToolbarItem(placement: .confirmationAction) {
        Button("Save") { saveTask() }
      }
    }
    // Shown when Save is tapped with the name or assignee empty.
    .alert("Validation Error", isPresented: $showingAlert) {
      Button("OK", role: .cancel) { }
    } message: {
      Text("Please enter both name and assignee")
    }
    // Asks the user to confirm before the task is deleted.
    .confirmationDialog("Delete Task", isPresented: $showingDeleteConfirmation) {
      Button("Delete", role: .destructive) {
        viewModel.destroy(task)
        // The task no longer exists, so go back to the list.
        dismiss()
      }
      Button("Cancel", role: .cancel) { }
    } message: {
      Text("Are you sure you want to delete this task?")
    }
  }

  /// Validates the edits, then saves them to the task and goes back to the list.
  /// Shows an alert instead if the name or assignee is empty.
  private func saveTask() {
    // Don't save an incomplete task; show the alert and stay on this screen.
    guard TaskItem.isValid(name: name, assignedTo: assignedTo) else {
      showingAlert = true
      return
    }

    // Start from the original task so its id and dateAdded are kept,
    // then copy the edited fields onto it.
    var updated = task
    updated.name = name
    updated.assignedTo = assignedTo
    updated.dueDate = dueDate
    updated.completed = completed

    viewModel.update(updated)
    dismiss()
  }
}
