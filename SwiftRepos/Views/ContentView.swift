import SwiftUI

struct ContentView: View {
    @State private var viewModel = RepositoryViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.filteredRepos) { repo in
                NavigationLink(value: repo) { RepositoryRow(repo: repo) }
            }
            .navigationTitle("Swift Repos")
            .searchable(text: Bindable(viewModel).searchText, prompt: "Search repos")
            .navigationDestination(for: Repository.self) { repo in
                if let url = URL(string: repo.htmlURL) {
                    WebView(url: url)
                        .navigationTitle(repo.name)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .onAppear {
                if viewModel.repos.isEmpty { viewModel.loadRepositories() }
            }
        }
    }
}
