import Foundation

struct Book: Identifiable, Comparable {
    let id: UUID
    var title: String
    var author: String
    var gender: String
    var displayed: Bool

    init(
        id: UUID = UUID(),
        title: String,
        author: String,
        gender: String,
        displayed: Bool
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.gender = gender
        self.displayed = displayed
    }

    static func == (lhs: Book, rhs: Book) -> Bool {
        lhs.title == rhs.title && lhs.author == rhs.author
    }

    static func < (lhs: Book, rhs: Book) -> Bool {
        lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
    }
}
