import Combine
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: ViewModel

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        context.coordinator.webView = webView
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard context.coordinator.lastRequestID != viewModel.requestID,
              let url = viewModel.requestedURL else { return }

        context.coordinator.lastRequestID = viewModel.requestID
        webView.load(URLRequest(url: url))
    }

    @MainActor
    final class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        weak var webView: WKWebView?
        var lastRequestID = -1
        private var webViewOptionsSubscriber: AnyCancellable?

        init(parent: WebView) {
            self.parent = parent
            super.init()

            webViewOptionsSubscriber = parent.viewModel.webViewOptionsPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] option in
                    self?.handle(option)
                }
        }

        deinit {
            webViewOptionsSubscriber?.cancel()
        }

        private func handle(_ option: WebViewOptions) {
            guard let webView else { return }

            switch option {
            case .back:
                if webView.canGoBack { webView.goBack() }
            case .forward:
                if webView.canGoForward { webView.goForward() }
            case .share:
                parent.viewModel.presentShareSheet(for: webView.url)
            case .refresh:
                if webView.url == nil {
                    parent.viewModel.load()
                } else {
                    webView.reload()
                }
            case .stop:
                webView.stopLoading()
                publishState(from: webView)
            }
        }

        func webView(
            _ webView: WKWebView,
            didStartProvisionalNavigation navigation: WKNavigation?
        ) {
            publishState(from: webView)
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation?) {
            publishState(from: webView)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
            publishState(from: webView)
        }

        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation?,
            withError error: Error
        ) {
            publishState(from: webView)
        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation?,
            withError error: Error
        ) {
            publishState(from: webView)
        }

        private func publishState(from webView: WKWebView) {
            parent.viewModel.updateNavigationState(
                canGoBack: webView.canGoBack,
                canGoForward: webView.canGoForward,
                isLoading: webView.isLoading,
                url: webView.url
            )
        }
    }
}

