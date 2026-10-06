# Lab 06: Simple Contacts

**Platform: Swift (SwiftUI)**

A contacts app following `Lab06_Swift_SimpleContacts.pdf`, using SwiftData for local persistence and PhotosUI for contact photos. Built and tested with **iPhone 17 Pro**.

## Run

1. Open `SimpleContacts.xcodeproj` in Xcode.
2. Select the `SimpleContacts` scheme and **iPhone 17 Pro** simulator.
3. Press Command-R to run. The app starts with an empty contact list on a fresh installation.

Requires iOS 17 or later. No external packages or API keys are needed.

## Features

- Add contacts with name, email, and multiline details.
- Tap a contact to edit its information through `@Bindable` fields.
- Search names with a case-insensitive, localized substring query.
- Sort names alphabetically in either direction.
- Swipe a contact left to delete it.
- Select an image using the system Photos picker. Image data uses SwiftData external storage.
- Keep contacts, edits, and photos across app launches.

The model lives in `SimpleContacts/Models/Person.swift`; navigation, queries, and editing are organized in `SimpleContacts/Views/`. The app uses the lab's insert-first flow: returning from a blank new contact leaves a tappable **New Person** row.

## Tests

Press Command-U in Xcode. `SimpleContactsTests/PersonTests.swift` contains the five required Swift Testing tests for initialization, insertion, deletion, sorting, and search, plus reverse sorting and edit/photo persistence tests. Each model test uses a fresh in-memory container.

`SimpleContactsUITests` exercises adding, editing, searching, sorting, deleting, selecting a real photo, and relaunch persistence, and attaches screenshots of the workflow. Use a simulator with at least one sample image in its Photos library (the default simulator images work).

Verified on iPhone 17 Pro with iOS 26.5: **8 tests passed, 0 failed** (7 model tests and 1 complete UI workflow test).

## Submission

- Platform: **Swift**
- Repository: <https://github.com/hlabda/hw_lab_hlabda>
- Branch: `hw_lab6_SimpleContacts`
- Lab branch: <https://github.com/hlabda/hw_lab_hlabda/tree/hw_lab6_SimpleContacts>
- Screenshots: saved in the `Screenshots/` folder, with a separate ZIP prepared for Canvas.
