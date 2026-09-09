import SwiftUI

struct DefinitionView: View {
    let viewModel: CardViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.systemBackground), Color.red.opacity(0.08)],
                startPoint: .top,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 26) {
                VStack(spacing: 8) {
                    Image(systemName: "text.book.closed.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.red.gradient)

                    Text("Definition")
                        .font(.largeTitle.bold())

                    Text(viewModel.flashcard.command)
                        .font(.subheadline.monospaced().weight(.medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                ZStack {
                    VStack(spacing: 14) {
                        Text(viewModel.flashcard.definition)
                            .font(.title3.weight(.medium))
                            .multilineTextAlignment(.center)
                            .padding()

                        Label("Swipe back for another card", systemImage: "arrow.backward")
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 350, height: 200)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.secondarySystemBackground))
                        .shadow(color: .black.opacity(0.09), radius: 18, y: 9)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray)
                )
                .accessibilityIdentifier("definition-card")
            }
            .padding(.bottom, 48)
        }
        .navigationTitle("Answer")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DefinitionView(viewModel: CardViewModel())
    }
}
