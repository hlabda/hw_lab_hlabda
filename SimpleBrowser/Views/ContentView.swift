import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(viewModel: viewModel)
                .padding(.horizontal)
                .padding(.vertical, 10)

            Divider()

            WebView(viewModel: viewModel)
                .accessibilityIdentifier("webView")

            Divider()

            BottomBar(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.shouldShowShareSheet) {
            if let url = viewModel.shareURL {
                ShareSheet(activityItems: [url])
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
