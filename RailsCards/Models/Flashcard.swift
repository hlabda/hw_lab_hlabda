import Foundation

struct Flashcard: Equatable {
    var command: String
    var definition: String

    init(command: String, definition: String) {
        self.command = command
        self.definition = definition
    }
}
