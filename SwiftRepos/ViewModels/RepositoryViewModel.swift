import Foundation
import Observation

@Observable
class RepositoryViewModel {
    var repos: [Repository] = []
    var searchText = ""

    var filteredRepos: [Repository] {
        guard !searchText.isEmpty else { return repos }
        return repos.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    @ObservationIgnored private let parser = Parser()

    func loadRepositories() {
        parser.fetchRepositories { [weak self] repos in
            self?.repos = repos
        }
    }
}
