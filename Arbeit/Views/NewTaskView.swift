import SwiftUI

/// A form for entering a new task's name, assignee and due date.
struct NewTaskView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(TasksViewModel.self) private var viewModel

  @State private var name = ""
  @State private var assignedTo = ""
  @State private var dueDate = Date()
  @State private var showingAlert = false

  /// Builds the form with Cancel and Save buttons and the validation alert.
  var body: some View {
    NavigationStack {
      Form {
        Section(header: Text("Task Details")) {
          TextField("Task Name", text: $name)
          TextField("Assigned To", text: $assignedTo)
          DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
        }
      }
      .navigationTitle("New Task")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") { saveTask() }
        }
      }
      .alert("Validation Error", isPresented: $showingAlert) {
        Button("OK", role: .cancel) { }
      } message: {
        Text("Please enter both name and assignee")
      }
    }
  }

  /// Validates the form, then saves the new task and closes the form.
  /// Shows an alert instead if the name or assignee is empty.
  private func saveTask() {
    guard TaskItem.isValid(name: name, assignedTo: assignedTo) else {
      showingAlert = true
      return
    }

    let newTask = TaskItem(
      name: name,
      assignedTo: assignedTo,
      dueDate: dueDate,
      dateAdded: Date(),
      completed: false
    )

    viewModel.add(newTask)
    dismiss()
  }
}
