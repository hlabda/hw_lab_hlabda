import Foundation
import FirebaseFirestore

/// A single task stored as one document in the Firestore "tasks" collection.
/// - Identifiable: lets SwiftUI lists tell tasks apart by `id`.
/// - Comparable: lets an array of tasks be sorted with `.sorted()`.
/// - Codable: lets Firestore convert a task to and from a document automatically.
/// - Hashable: lets a task be used as a `NavigationLink` value.
struct TaskItem: Identifiable, Comparable, Codable, Hashable {

  // MARK: Fields
  /// Firestore document ID; nil until the task has been saved to Firestore.
  /// @DocumentID fills it in from the document's ID when a task is read.
  @DocumentID var id: String?
  /// What the task is, e.g. "Finish Lab 7".
  var name: String
  /// The person responsible for the task.
  var assignedTo: String
  /// When the task should be finished.
  var dueDate: Date
  /// When the task was created; set once and never edited.
  var dateAdded: Date
  /// Whether the task has been finished.
  var completed: Bool

  // MARK: Codable
  /// Maps each property to its field name in the Firestore document.
  /// The names match the properties, so documents use the same field names as the code.
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case assignedTo
    case dueDate
    case dateAdded
    case completed
  }

  // MARK: Comparable
  /// Two tasks are equal when they have the same name, assignee and due date.
  /// The document ID and completed flag are intentionally ignored.
  static func ==(lhs: TaskItem, rhs: TaskItem) -> Bool {
    return lhs.name == rhs.name && lhs.assignedTo == rhs.assignedTo && lhs.dueDate == rhs.dueDate
  }

  /// Orders tasks alphabetically by name so a list of tasks can be sorted.
  static func <(lhs: TaskItem, rhs: TaskItem) -> Bool {
    return lhs.name < rhs.name
  }

  // MARK: Hashable
  /// Hashes the same fields that `==` compares, so equal tasks always have equal hashes.
  /// Required for `NavigationLink(value:)` to push a TaskItem.
  func hash(into hasher: inout Hasher) {
    // Only combine the fields `==` uses; hashing extra fields (like `completed`)
    // could give two "equal" tasks different hashes, which breaks Hashable's rules.
    hasher.combine(name)
    hasher.combine(assignedTo)
    hasher.combine(dueDate)
  }
}

// MARK: - Validation
extension TaskItem {
  /// Returns true only when both the task name and the assignee are filled in.
  /// It's static so forms can check their text fields before a TaskItem exists.
  static func isValid(name: String, assignedTo: String) -> Bool {
    return !name.isEmpty && !assignedTo.isEmpty
  }
}
