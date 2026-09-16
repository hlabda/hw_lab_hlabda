import XCTest
@testable import BookManager

@MainActor
final class LibraryTests: XCTestCase {
    func testLibraryStartsWithAllSeedBooksInTitleOrder() {
        let library = Library()

        XCTAssertEqual(library.books.count, 77)
        XCTAssertEqual(library.books, library.books.sorted())
        XCTAssertEqual(library.books.first?.title, "1984")
    }

    func testLibraryFiltersBooksByAuthorAndGender() {
        let library = Library()

        XCTAssertEqual(library.getBooksFor("William Shakespeare").count, 14)
        XCTAssertEqual(library.getBooksFor("Jane Austen").count, 6)
        XCTAssertEqual(library.getFemaleAuthoredBooks().count, 19)
        XCTAssertEqual(library.getMaleAuthoredBooks().count, 58)
    }

    func testAddBookTrimsFieldsAndKeepsLibrarySorted() {
        let library = Library(books: [])

        let added = library.addBookToLibrary(
            title: "  Diary of a Young Girl  ",
            author: "  Anne Frank  ",
            gender: "Female",
            displayed: true
        )

        XCTAssertTrue(added)
        XCTAssertEqual(library.books.count, 1)
        XCTAssertEqual(library.books[0].title, "Diary of a Young Girl")
        XCTAssertEqual(library.books[0].author, "Anne Frank")
    }

    func testAddBookRejectsMissingRequiredFields() {
        let library = Library(books: [])

        let added = library.addBookToLibrary(
            title: "   ",
            author: "Anne Frank",
            gender: "Female",
            displayed: true
        )

        XCTAssertFalse(added)
        XCTAssertTrue(library.books.isEmpty)
    }

    func testRemoveBooksDeletesRequestedRows() {
        let library = Library(books: [
            Book(title: "A", author: "Author", gender: "Other", displayed: true),
            Book(title: "B", author: "Author", gender: "Other", displayed: true)
        ])

        library.removeBooks(at: IndexSet(integer: 0))

        XCTAssertEqual(library.books.map(\.title), ["B"])
    }
}
