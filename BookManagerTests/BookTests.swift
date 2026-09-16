import Foundation
import XCTest
@testable import BookManager

final class BookTests: XCTestCase {
    func testBooksWithMatchingTitleAndAuthorAreEqual() {
        let first = Book(
            title: "Emma",
            author: "Jane Austen",
            gender: "Female",
            displayed: true
        )
        let second = Book(
            title: "Emma",
            author: "Jane Austen",
            gender: "Female",
            displayed: false
        )

        XCTAssertEqual(first, second)
        XCTAssertNotEqual(first.id, second.id)
    }

    func testBooksSortAlphabeticallyByTitle() {
        let books = [
            Book(title: "Dracula", author: "Bram Stoker", gender: "Male", displayed: true),
            Book(title: "1984", author: "George Orwell", gender: "Male", displayed: true),
            Book(title: "Emma", author: "Jane Austen", gender: "Female", displayed: true)
        ]

        XCTAssertEqual(books.sorted().map(\.title), ["1984", "Dracula", "Emma"])
    }
}
