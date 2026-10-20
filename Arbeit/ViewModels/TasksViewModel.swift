import Foundation
import Observation

/// The single view model shared by every screen; it passes task actions through to the repository.
@Observable
class TasksViewModel {
  @ObservationIgnored private let repository: TaskRepository

  /// Creates the view model with the given repository (a new one by default),
  /// which lets tests inject a different repository.
  init(repository: TaskRepository = TaskRepository()) {
    self.repository = repository
  }

  /// The current tasks, read straight from the repository, which is the source of truth.
  var tasks: [TaskItem] {
    repository.tasks
  }

  /// Saves a new task.
  func add(_ task: TaskItem) {
    repository.create(task)
  }

  /// Saves changes to an existing task.
  func update(_ task: TaskItem) {
    repository.update(task)
  }

  /// Deletes a task.
  func destroy(_ task: TaskItem) {
    repository.delete(task)
  }
}
