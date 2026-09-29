import XCTest

final class SwiftReposUITests: XCTestCase {
    func testLiveListSearchAndWebNavigation() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        let alamofire = app.staticTexts["Alamofire"]
        XCTAssertTrue(alamofire.waitForExistence(timeout: 30))
        screenshot("01-Swift-Repositories")

        let search = app.searchFields.firstMatch
        if !search.exists { app.swipeDown() }
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.tap()
        search.typeText("ALAMO")
        XCTAssertTrue(alamofire.exists)
        XCTAssertFalse(app.staticTexts["SwiftLint"].exists)
        app.keyboards.buttons["Search"].tap()
        screenshot("02-Case-Insensitive-Search")

        alamofire.tap()
        XCTAssertTrue(app.webViews.firstMatch.waitForExistence(timeout: 20))
        let githubContent = app.webViews.firstMatch.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] 'Alamofire'")).firstMatch
        XCTAssertTrue(githubContent.waitForExistence(timeout: 45))
        screenshot("03-GitHub-WebView")
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(alamofire.waitForExistence(timeout: 5))
    }

    private func screenshot(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
