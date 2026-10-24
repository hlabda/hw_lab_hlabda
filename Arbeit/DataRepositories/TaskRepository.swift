import Foundation
import Observation
import FirebaseFirestore

/// Reads and writes TaskItem documents in Firestore and keeps `tasks` in sync with the database.
/// This is the only class that talks to Firestore; everything else goes through it.
@Observable
class TaskRepository {
  /// Name of the Firestore collection that holds the tasks.
  @ObservationIgnored private let path: String = "tasks"
  /// Connection to the Firestore database set up by FirebaseApp.configure().
  @ObservationIgnored private let store = Firestore.firestore()
  /// Handle for the real-time listener, kept so it can be removed in deinit.
  @ObservationIgnored private var listener: ListenerRegistration?
  /// The actual task array behind the `tasks` property below.
  @ObservationIgnored private var storedTasks: [TaskItem] = []

  /// The latest tasks from Firestore.
  /// @Observable skips notifying views when a new value is `==` to the old one, and
  /// TaskItem's `==` ignores `completed`, so a stored property here would silently drop
  /// updates where only `completed` changed. Notifying by hand on every set avoids that.
  var tasks: [TaskItem] {
    get {
      // Tell SwiftUI that the view reading this property depends on it.
      access(keyPath: \.tasks)
      return storedTasks
    }
    set {
      // Tell SwiftUI the value changed so every view that reads `tasks` redraws.
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
      // The closure runs once right away with the current data, then again
      // every time a task is added, changed or deleted (by this app or anyone else).
      // [weak self] stops the listener from keeping the repository alive forever.
      .addSnapshotListener { [weak self] querySnapshot, error in
        // If the repository has already been released, there's nothing to update.
        guard let self = self else { return }

        // Stop here if Firestore couldn't deliver the data (for example, no permission).
        if let error = error {
          print("Error getting tasks: \(error.localizedDescription)")
          return
        }

        // Turn each document into a TaskItem. compactMap with try? skips any
        // document that can't be decoded instead of crashing the app.
        self.tasks = querySnapshot?.documents.compactMap { document in
          try? document.data(as: TaskItem.self)
        } ?? []
      }
  }

  // MARK: CRUD methods
  /// Adds a new task document; Firestore generates its document ID.
  func create(_ task: TaskItem) {
    do {
      // addDocument(from:) encodes the task with Codable and saves it as a new document.
      // The listener in get() then picks up the new task, so `tasks` doesn't need editing here.
      _ = try store.collection(path).addDocument(from: task)
    } catch {
      print("Error creating task: \(error.localizedDescription)")
    }
  }

  /// Overwrites an existing task document with the task's current values.
  func update(_ task: TaskItem) {
    // A task without an ID was never saved, so there's no document to update.
    guard let taskId = task.id else {
      print("Error updating task: Task ID is missing")
      return
    }

    do {
      // setData(from:) replaces the whole document with the task's current fields.
      try store.collection(path).document(taskId).setData(from: task)
    } catch {
      print("Error updating task: \(error.localizedDescription)")
    }
  }

  /// Deletes the task's document from Firestore.
  func delete(_ task: TaskItem) {
    // A task without an ID was never saved, so there's no document to delete.
    guard let taskId = task.id else {
      print("Error deleting task: Task ID is missing")
      return
    }

    // The completion closure runs after Firestore finishes; error is nil on success.
    store.collection(path).document(taskId).delete { error in
      if let error = error {
        print("Error deleting task: \(error.localizedDescription)")
      }
    }
  }
}
