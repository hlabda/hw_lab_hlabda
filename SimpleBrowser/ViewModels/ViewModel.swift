import Combine
import Foundation

enum WebViewOptions {
    case back
    case forward
    case share
    case refresh
    case stop
}

@MainActor
final class ViewModel: ObservableObject {
    @Published var urlString: String
    @Published var shouldShowShareSheet = false
    @Published private(set) var shareURL: URL?
    @Published private(set) var requestID = 0
    @Published private(set) var canGoBack = false
    @Published private(set) var canGoForward = false
    @Published private(set) var isLoading = false

    let webViewOptionsPublisher = PassthroughSubject<WebViewOptions, Never>()

    init(urlString: String = ProcessInfo.processInfo.environment["UITEST_URL"] ?? "apple.com") {
        self.urlString = urlString
    }

    var requestedURL: URL? {
        Self.normalizedURL(from: urlString)
    }

    func load() {
        guard requestedURL != nil else { return }
        requestID += 1
    }

    func goBack() {
        webViewOptionsPublisher.send(.back)
    }

    func goForward() {
        webViewOptionsPublisher.send(.forward)
    }

    func share() {
        webViewOptionsPublisher.send(.share)
    }

    func refresh() {
        webViewOptionsPublisher.send(.refresh)
    }

    func stop() {
        webViewOptionsPublisher.send(.stop)
    }

    func updateNavigationState(
        canGoBack: Bool,
        canGoForward: Bool,
        isLoading: Bool,
        url: URL?
    ) {
        self.canGoBack = canGoBack
        self.canGoForward = canGoForward
        self.isLoading = isLoading

        if let url, url.scheme == "http" || url.scheme == "https" {
            urlString = url.absoluteString
        }
    }

    func presentShareSheet(for url: URL?) {
        shareURL = url ?? requestedURL
        shouldShowShareSheet = shareURL != nil
    }

    static func normalizedURL(from text: String) -> URL? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if let url = URL(string: trimmed),
           let scheme = url.scheme?.lowercased(),
           scheme == "http" || scheme == "https" {
            return url
        }

        return URL(string: "https://\(trimmed)")
    }
}
