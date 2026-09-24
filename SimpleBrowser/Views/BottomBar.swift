import SwiftUI

struct BottomBar: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack {
            navigationButton(
                systemName: "chevron.left",
                label: "Back",
                identifier: "backButton",
                action: viewModel.goBack
            )
            .disabled(!viewModel.canGoBack)

            Spacer()

            navigationButton(
                systemName: "chevron.right",
                label: "Forward",
                identifier: "forwardButton",
                action: viewModel.goForward
            )
            .disabled(!viewModel.canGoForward)

            Spacer()

            navigationButton(
                systemName: "square.and.arrow.up",
                label: "Share",
                identifier: "shareButton",
                action: viewModel.share
            )
            .disabled(viewModel.requestedURL == nil)

            Spacer()

            navigationButton(
                systemName: "arrow.clockwise",
                label: "Reload",
                identifier: "reloadButton",
                action: viewModel.refresh
            )

            Spacer()

            navigationButton(
                systemName: "xmark",
                label: "Stop",
                identifier: "stopButton",
                action: viewModel.stop
            )
            .disabled(!viewModel.isLoading)
        }
        .font(.title3)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(.bar)
    }

    private func navigationButton(
        systemName: String,
        label: String,
        identifier: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .frame(width: 32, height: 32)
        }
        .accessibilityLabel(label)
        .accessibilityIdentifier(identifier)
    }
}

