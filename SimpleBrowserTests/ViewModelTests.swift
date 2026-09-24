import Combine
import XCTest
@testable import SimpleBrowser

@MainActor
final class ViewModelTests: XCTestCase {
    func testAddsHTTPSWhenSchemeIsMissing() {
        XCTAssertEqual(
            ViewModel.normalizedURL(from: "apple.com")?.absoluteString,
            "https://apple.com"
        )
    }

    func testPreservesExistingHTTPSURL() {
        XCTAssertEqual(
            ViewModel.normalizedURL(from: "https://example.com/path")?.absoluteString,
            "https://example.com/path"
        )
    }

    func testRejectsBlankURL() {
        XCTAssertNil(ViewModel.normalizedURL(from: "   "))
    }

    func testBackButtonPublishesBackAction() {
        let viewModel = ViewModel()
        var receivedOption: WebViewOptions?
        let subscription = viewModel.webViewOptionsPublisher.sink {
            receivedOption = $0
        }

        viewModel.goBack()

        guard case .back = receivedOption else {
            XCTFail("Expected the back navigation action")
            return
        }
        withExtendedLifetime(subscription) {}
    }
}

