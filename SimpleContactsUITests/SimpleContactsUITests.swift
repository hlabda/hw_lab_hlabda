import XCTest

final class SimpleContactsUITests: XCTestCase {
    @MainActor
    func testContactWorkflow() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.navigationBars["My Contacts"].waitForExistence(timeout: 10))

        // Remove only this app's previous test contacts to make reruns repeatable.
        for name in ["Alex Heimann", "An Heimann", "Tom Brady", "Tim Daigle", "Temporary Contact", "New Person"] {
            let row = app.cells.containing(.staticText, identifier: name).firstMatch
            while row.exists {
                row.swipeLeft()
                app.buttons["Delete"].tap()
            }
        }
        screenshot("01-Empty-Contacts")

        addPerson(app, name: "Alex Heimann", email: "alex@example.com", details: "Friend and course instructor.", captureForm: true)
        addPerson(app, name: "An Heimann", email: "an@example.com", details: "Family contact.")
        addPerson(app, name: "Tom Brady", email: "tom@example.com", details: "Football contact.")
        addPerson(app, name: "Tim Daigle", email: "tim@example.com", details: "Colleague from class.")
        XCTAssertTrue(app.cells.element(boundBy: 0).staticTexts["Alex Heimann"].exists)
        screenshot("04-Contacts-A-to-Z")

        let search = app.searchFields.firstMatch
        if !search.exists { app.swipeDown() }
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.tap()
        search.typeText("HEIM")
        app.keyboards.buttons["Search"].tap()
        XCTAssertTrue(app.staticTexts["Alex Heimann"].exists)
        XCTAssertTrue(app.staticTexts["An Heimann"].exists)
        XCTAssertFalse(app.staticTexts["Tom Brady"].exists)
        screenshot("05-Case-Insensitive-Search")
        search.tap()
        search.buttons["Clear text"].tap()
        search.typeText("Nobody")
        app.keyboards.buttons["Search"].tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label BEGINSWITH 'No Results'")).firstMatch.waitForExistence(timeout: 5))
        screenshot("06-No-Search-Results")
        if app.buttons["Cancel"].exists {
            app.buttons["Cancel"].tap()
        } else {
            app.buttons["close"].tap()
        }

        app.buttons["sortMenu"].tap()
        screenshot("07-Sort-Options")
        app.buttons["Name (Z-A)"].tap()
        XCTAssertTrue(app.cells.element(boundBy: 0).staticTexts["Tom Brady"].waitForExistence(timeout: 5))
        screenshot("08-Contacts-Z-to-A")

        app.staticTexts["Alex Heimann"].tap()
        let details = app.textFields["personDetails"].exists
            ? app.textFields["personDetails"] : app.textViews["personDetails"]
        details.tap()
        details.typeText("Available after 3 PM. ")
        app.buttons["Done"].tap()
        let editedDetails = details.value as? String
        XCTAssertTrue(editedDetails?.contains("Available after 3 PM.") == true)
        app.buttons["selectPhoto"].tap()
        XCTAssertTrue(app.buttons["Cancel"].waitForExistence(timeout: 10))
        screenshot("09-Photo-Picker")
        let photo = app.images.matching(NSPredicate(format: "label BEGINSWITH 'Photo,'")).firstMatch
        XCTAssertTrue(photo.waitForExistence(timeout: 10), "Add a sample image to the simulator's Photos library before running this UI test.")
        // PhotosUI's grid exposes thumbnails but can report them as not hittable.
        // Tap the center of the thumbnail's observed frame instead.
        photo.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        XCTAssertTrue(app.images["contactPhoto"].waitForExistence(timeout: 10))
        screenshot("10-Contact-with-Photo")
        backToContacts(app)

        addPerson(app, name: "Temporary Contact", email: "temp@example.com", details: "This contact will be deleted.")
        let temporary = app.cells.containing(.staticText, identifier: "Temporary Contact").firstMatch
        temporary.swipeLeft()
        screenshot("11-Swipe-to-Delete")
        app.buttons["Delete"].tap()
        XCTAssertFalse(app.staticTexts["Temporary Contact"].exists)
        screenshot("12-Contact-Deleted")

        // Backgrounding gives SwiftData's automatic save a lifecycle opportunity.
        XCUIDevice.shared.press(.home)
        app.activate()
        app.terminate()
        app.launch()
        XCTAssertTrue(app.staticTexts["Alex Heimann"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.staticTexts["Temporary Contact"].exists)
        app.staticTexts["Alex Heimann"].tap()
        let savedDetails = app.textFields["personDetails"].exists
            ? app.textFields["personDetails"] : app.textViews["personDetails"]
        XCTAssertEqual(savedDetails.value as? String, editedDetails)
        XCTAssertTrue(app.images["contactPhoto"].exists)
        screenshot("13-Edits-and-Photo-Persist-After-Relaunch")
        backToContacts(app)
    }

    @MainActor
    private func addPerson(_ app: XCUIApplication, name: String, email: String, details: String, captureForm: Bool = false) {
        app.buttons["addPerson"].tap()
        XCTAssertTrue(app.navigationBars["Edit Person"].waitForExistence(timeout: 5))
        if captureForm { screenshot("02-New-Contact-Form") }
        app.textFields["personName"].tap()
        app.textFields["personName"].typeText(name)
        app.textFields["personEmail"].tap()
        app.textFields["personEmail"].typeText(email)
        let detailsField = app.textFields["personDetails"].exists
            ? app.textFields["personDetails"] : app.textViews["personDetails"]
        detailsField.tap()
        detailsField.typeText(details)
        app.buttons["Done"].tap()
        if captureForm { screenshot("03-Contact-Information-and-Details") }
        backToContacts(app)
        XCTAssertTrue(app.staticTexts[name].waitForExistence(timeout: 5))
    }

    @MainActor
    private func backToContacts(_ app: XCUIApplication) {
        app.navigationBars["Edit Person"].buttons.firstMatch.tap()
    }

    @MainActor
    private func screenshot(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
