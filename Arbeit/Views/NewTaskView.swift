import SwiftUI

/// A form for entering a new task's name, assignee and due date.
struct NewTaskView: View {
  /// Closes this screen when it's shown as a sheet.
  @Environment(\.dismiss) private var dismiss
  /// The shared view model, used to save the new task.
  @Environment(TasksViewModel.self) private var viewModel

  // What the user has typed or picked so far. Each field is bound to one of these.
  @State private var name = ""
  @State private var assignedTo = ""
  @State private var dueDate = Date()
  /// Whether the validation alert is showing.
  @State private var showingAlert = false

  /// Builds the form with Cancel and Save buttons and the validation alert.
  var body: some View {
    NavigationStack {
      Form {
        Section(header: Text("Task Details")) {
          // The $ creates a two-way binding: typing updates the @State value and vice versa.
          TextField("Task Name", text: $name)
          TextField("Assigned To", text: $assignedTo)
          // displayedComponents: .date shows only the date, with no time picker.
          DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
        }
      }
      .navigationTitle("New Task")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        // Cancel on the left closes the form without saving.
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
        // Save on the right validates and saves the task.
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
    }
  }

  /// Validates the form, then saves the new task and closes the form.
  /// Shows an alert instead if the name or assignee is empty.
  private func saveTask() {
    // Don't save an incomplete task; show the alert and keep the form open.
    guard TaskItem.isValid(name: name, assignedTo: assignedTo) else {
      showingAlert = true
      return
    }

    // Build the task from the form. It has no id yet; Firestore assigns one when it's saved.
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
