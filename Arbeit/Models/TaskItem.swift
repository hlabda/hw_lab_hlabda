import Foundation
import FirebaseFirestore

/// A single task stored as one document in the Firestore "tasks" collection.
struct TaskItem: Identifiable, Comparable, Codable, Hashable {

  // MARK: Fields
  /// Firestore document ID; nil until the task has been saved to Firestore.
  @DocumentID var id: String?
  var name: String
  var assignedTo: String
  var dueDate: Date
  var dateAdded: Date
  var completed: Bool

  // MARK: Codable
  /// Maps each property to its field name in the Firestore document.
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
    hasher.combine(name)
    hasher.combine(assignedTo)
    hasher.combine(dueDate)
  }
}

// MARK: - Validation
extension TaskItem {
  /// Returns true only when both the task name and the assignee are filled in.
  static func isValid(name: String, assignedTo: String) -> Bool {
    return !name.isEmpty && !assignedTo.isEmpty
  }
}
