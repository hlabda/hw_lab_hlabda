import XCTest

final class NewBookFlowUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testAddingBookMakesItAppearInLibrary() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["New Book"].tap()

        let titleField = app.textFields["Title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 3))
        titleField.tap()
        titleField.typeText("Codex Test Book")

        let authorField = app.textFields["Author"]
        authorField.tap()
        authorField.typeText("Test Author")

        app.keyboards.buttons["Return"].tap()

        let addButton = app.buttons["Add Book"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 3))
        addButton.tap()

        let confirmation = app.alerts["Book Added"]
        XCTAssertTrue(confirmation.waitForExistence(timeout: 3))
        confirmation.buttons["OK"].tap()

        XCTAssertEqual(titleField.value as? String, "Title")
        XCTAssertEqual(authorField.value as? String, "Author")

        app.tabBars.buttons["Library"].tap()

        let addedBook = app.staticTexts["Codex Test Book"]
        for _ in 0..<5 where !addedBook.exists {
            app.swipeUp()
        }

        XCTAssertTrue(addedBook.exists, "The newly added book should appear in the shared library.")
        XCTAssertTrue(app.staticTexts["Test Author"].exists)
    }
}
