import Foundation
import Observation

/// The single view model shared by every screen; it passes task actions through to the repository.
/// Views call this instead of the repository, so they never deal with Firestore directly.
@Observable
class TasksViewModel {
  /// Where the tasks are stored and loaded from.
  /// Ignored for observation because the repository is never replaced, only its tasks change.
  @ObservationIgnored private let repository: TaskRepository

  /// Creates the view model with the given repository (a new one by default),
  /// which lets tests inject a different repository.
  init(repository: TaskRepository = TaskRepository()) {
    self.repository = repository
  }

  /// The current tasks, read straight from the repository, which is the source of truth.
  /// Because the repository is @Observable, views reading this redraw when the tasks change.
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
