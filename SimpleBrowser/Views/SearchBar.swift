import SwiftUI

struct SearchBar: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack(spacing: 8) {
            Text("URL:")
                .fontWeight(.semibold)

            TextField("URL", text: $viewModel.urlString)
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .submitLabel(.go)
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("urlField")
                .onSubmit(viewModel.load)

            Button(action: viewModel.load) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
            }
            .accessibilityLabel("Open URL")
            .accessibilityIdentifier("openURLButton")
            .disabled(viewModel.requestedURL == nil)
        }
    }
}

