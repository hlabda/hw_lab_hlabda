import Testing
import Foundation
@testable import Arbeit

/// Unit tests for TaskItem's validation, equality and sorting. None of them touch Firebase.
@MainActor
struct TaskItemTests {

  /// A fixed date shared by every sample. Using Date() instead would give each sample a
  /// slightly different time, and the equality test would fail for the wrong reason.
  private static let fixedDate = Date(timeIntervalSince1970: 1_700_000_000)

  /// Builds a sample task. Every sample shares the same fixed dates so two samples compare equal.
  private func sample(name: String = "Write lab",
                      assignedTo: String = "Prof H",
                      dueDate: Date = TaskItemTests.fixedDate) -> TaskItem {
    TaskItem(
      name: name,
      assignedTo: assignedTo,
      dueDate: dueDate,
      dateAdded: TaskItemTests.fixedDate,
      completed: false
    )
  }

  /// An empty task name should fail validation.
  @Test func validationRejectsEmptyName() {
    #expect(TaskItem.isValid(name: "", assignedTo: "someone") == false)
  }

  /// An empty assignee should fail validation.
  @Test func validationRejectsEmptyAssignee() {
    #expect(TaskItem.isValid(name: "something", assignedTo: "") == false)
  }

  /// A name and an assignee together should pass validation.
  @Test func validationAcceptsBothPresent() {
    #expect(TaskItem.isValid(name: "something", assignedTo: "someone") == true)
  }

  /// Tasks with the same name, assignee and due date are equal even if their IDs and completion differ.
  @Test func equalityIgnoresIdAndCompletion() {
    // Two samples with identical fields, then give them different IDs and completion.
    var a = sample()
    var b = sample()
    a.id = "abc"
    b.id = "xyz"
    b.completed = true  // completed is not part of `==`
    #expect(a == b)     // same name, assignedTo, dueDate
  }

  /// Sorting a list of tasks orders them alphabetically by name.
  @Test func sortsByName() {
    let apple = sample(name: "Apple")
    let banana = sample(name: "Banana")
    let cherry = sample(name: "Cherry")
    // Start out of order; .sorted() uses TaskItem's < to put them in name order.
    let sorted = [cherry, apple, banana].sorted()
    #expect(sorted.map(\.name) == ["Apple", "Banana", "Cherry"])
  }
}
