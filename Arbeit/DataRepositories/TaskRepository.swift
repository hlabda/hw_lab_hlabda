import Foundation
import Observation
import FirebaseFirestore

/// Reads and writes TaskItem documents in Firestore and keeps `tasks` in sync with the database.
@Observable
class TaskRepository {
  @ObservationIgnored private let path: String = "tasks"
  @ObservationIgnored private let store = Firestore.firestore()
  @ObservationIgnored private var listener: ListenerRegistration?
  @ObservationIgnored private var storedTasks: [TaskItem] = []

  /// The latest tasks from Firestore.
  /// @Observable skips notifying views when a new value is `==` to the old one, and
  /// TaskItem's `==` ignores `completed`, so a stored property here would silently drop
  /// updates where only `completed` changed. Notifying by hand on every set avoids that.
  var tasks: [TaskItem] {
    get {
      access(keyPath: \.tasks)
      return storedTasks
    }
    set {
      withMutation(keyPath: \.tasks) {
        storedTasks = newValue
      }
    }
  }

  /// Creates the repository and immediately starts listening for task changes.
  init() {
    self.get()
  }

  /// Stops the Firestore listener when the repository is released so it doesn't leak.
  deinit {
    listener?.remove()
  }

  /// Attaches a real-time snapshot listener to the "tasks" collection.
  /// Every time the collection changes, the documents are decoded into `tasks`.
  func get() {
    listener = store.collection(path)
      .addSnapshotListener { [weak self] querySnapshot, error in
        guard let self = self else { return }

        if let error = error {
          print("Error getting tasks: \(error.localizedDescription)")
          return
        }

        self.tasks = querySnapshot?.documents.compactMap { document in
          try? document.data(as: TaskItem.self)
        } ?? []
      }
  }

  // MARK: CRUD methods
  /// Adds a new task document; Firestore generates its document ID.
  func create(_ task: TaskItem) {
    do {
      _ = try store.collection(path).addDocument(from: task)
    } catch {
      print("Error creating task: \(error.localizedDescription)")
    }
  }

  /// Overwrites an existing task document with the task's current values.
  func update(_ task: TaskItem) {
    guard let taskId = task.id else {
      print("Error updating task: Task ID is missing")
      return
    }

    do {
      try store.collection(path).document(taskId).setData(from: task)
    } catch {
      print("Error updating task: \(error.localizedDescription)")
    }
  }

  /// Deletes the task's document from Firestore.
  func delete(_ task: TaskItem) {
    guard let taskId = task.id else {
      print("Error deleting task: Task ID is missing")
      return
    }

    store.collection(path).document(taskId).delete { error in
      if let error = error {
        print("Error deleting task: \(error.localizedDescription)")
      }
    }
  }
}
