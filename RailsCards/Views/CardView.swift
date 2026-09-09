import SwiftUI

struct CardView: View {
    @State private var viewModel = CardViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(.systemBackground), Color.red.opacity(0.08)],
                    startPoint: .top,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 28) {
                    header

                    ZStack {
                        NavigationLink {
                            DefinitionView(viewModel: viewModel)
                        } label: {
                            VStack(spacing: 18) {
                                Label("RAILS COMMAND", systemImage: "terminal.fill")
                                    .font(.caption.weight(.bold))
                                    .tracking(1.2)
                                    .foregroundStyle(.red)

                                Text(viewModel.flashcard.command)
                                    .font(.system(.title3, design: .monospaced, weight: .semibold))
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 22)

                                Label("Tap to reveal", systemImage: "hand.tap")
                                    .font(.footnote.weight(.medium))
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
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
                    .accessibilityIdentifier("command-card")
                    .onAppear {
                        viewModel.drawNewCard()
                    }

                    Text("A random card is drawn whenever this screen appears.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 24)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "diamond.fill")
                .font(.system(size: 34))
                .foregroundStyle(.red.gradient)
                .accessibilityHidden(true)

            Text("RailsCards")
                .font(.largeTitle.bold())

            Text("Ruby on Rails command deck")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("\(viewModel.deck.cards.count) CARDS")
                .font(.caption2.weight(.bold))
                .tracking(1.4)
                .foregroundStyle(.red)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(.red.opacity(0.1), in: Capsule())
        }
    }
}

#Preview {
    CardView()
}
