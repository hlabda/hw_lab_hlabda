import XCTest

final class SimpleBrowserUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testBrowserControlsAreVisible() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.textFields["urlField"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["backButton"].exists)
        XCTAssertTrue(app.buttons["forwardButton"].exists)
        XCTAssertTrue(app.buttons["shareButton"].exists)
        XCTAssertTrue(app.buttons["reloadButton"].exists)
        XCTAssertTrue(app.buttons["stopButton"].exists)
    }

    func testCaptureSubmissionScreenshots() {
        let app = XCUIApplication()
        app.launchEnvironment["UITEST_URL"] = "apple.com"
        app.launch()

        let urlField = app.textFields["urlField"]
        XCTAssertTrue(urlField.waitForExistence(timeout: 5))
        addScreenshot(named: "01-HomePage")

        app.terminate()
        app.launchEnvironment["UITEST_URL"] = "example.com"
        app.launch()

        let loadedURL = NSPredicate(format: "value CONTAINS 'example.com'")
        expectation(for: loadedURL, evaluatedWith: urlField)
        waitForExpectations(timeout: 10)
        addScreenshot(named: "02-URL-Navigation")

        app.buttons["shareButton"].tap()
        XCTAssertTrue(app.staticTexts["Copy"].waitForExistence(timeout: 5))
        addScreenshot(named: "03-Share-Sheet")
    }

    private func addScreenshot(named name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
