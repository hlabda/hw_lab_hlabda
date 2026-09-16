import SwiftUI

struct AppView: View {
    private enum Tab: String {
        case library
        case newBook
        case charts
    }

    @StateObject private var library = Library()
    @State private var selectedTab: Tab

    init() {
        let arguments = ProcessInfo.processInfo.arguments
        let requestedTab = arguments
            .firstIndex(of: "-screenshotTab")
            .flatMap { index in
                arguments.indices.contains(index + 1) ? Tab(rawValue: arguments[index + 1]) : nil
            }
        _selectedTab = State(initialValue: requestedTab ?? .library)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }
                .tag(Tab.library)

            NewBookView()
                .tabItem {
                    Label("New Book", systemImage: "rectangle.stack.badge.plus")
                }
                .tag(Tab.newBook)

            ChartsView()
                .tabItem {
                    Label("Charts", systemImage: "chart.bar.xaxis")
                }
                .tag(Tab.charts)
        }
        .environmentObject(library)
    }
}

#Preview {
    AppView()
}
