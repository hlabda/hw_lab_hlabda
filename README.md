# Lab 07: Arbeit Task Manager

**Platform: Swift (SwiftUI)**

A task manager following `Lab07_Swift_Arbeit`, storing tasks in the cloud with Firebase Firestore. Built and tested with **iPhone 17 Pro**.

## Run

1. Add your own `GoogleService-Info.plist` to the `Arbeit/` folder. It is not committed, because it identifies the Firebase project. Download it from Firebase console → Project settings → Your apps (bundle ID `edu.cmu.hlabda.Arbeit`).
2. Open `Arbeit.xcodeproj` in Xcode. Xcode fetches the Firebase package (`firebase-ios-sdk`, product `FirebaseFirestore`) automatically.
3. Select the `Arbeit` scheme and **iPhone 17 Pro** simulator, then press Command-R.

Requires iOS 17 or later. The Firestore database uses test-mode rules and a `tasks` collection.

## Features

- Live task list that updates through a Firestore snapshot listener.
- Add tasks with a name, assignee, and due date, from the + button or the New Task tab.
- Validation alert when the name or assignee is empty.
- Task details screen to edit fields, mark a task completed, and delete it with confirmation.
- Swipe a row left to delete a task.
- Completed tasks show a check mark and strikethrough.

The code is organized into `Models/TaskItem.swift`, `DataRepositories/TaskRepository.swift`, `ViewModels/TasksViewModel.swift`, and `Views/`. Every function and method is commented.

`TaskItem`'s `==` deliberately ignores `completed`. SwiftUI and `@Observable` use `==` to decide when to redraw, so marking a task completed would not update the list. `TaskRepository` notifies observers on every snapshot, and the list rows carry `completed` separately, so completion changes always appear.

## Tests

Press Command-U in Xcode. `ArbeitTests/TaskItemTests.swift` contains the five Swift Testing tests for validation, equality, and sorting. They do not need Firebase.

Verified on iPhone 17 Pro with iOS 26.5: **5 tests passed, 0 failed**.

## Submission

- Platform: **Swift**
- Repository: <https://github.com/hlabda/hw_lab_hlabda>
- Branch: `hw_lab7_Arbeit`
- Lab branch: <https://github.com/hlabda/hw_lab_hlabda/tree/hw_lab7_Arbeit>
- Screenshots: kept locally and submitted separately through Canvas; excluded from GitHub.
