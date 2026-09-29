import Testing
import Foundation
@testable import SwiftRepos

@MainActor
struct RepositoryViewModelTests {
    private func sampleRepos() -> [Repository] {
        [
            Repository(id: 1, name: "Alamofire", itemDescription: "Elegant HTTP Networking in Swift", htmlURL: "https://github.com/Alamofire/Alamofire", stargazersCount: 40_000),
            Repository(id: 2, name: "SwiftLint", itemDescription: "A tool to enforce Swift style", htmlURL: "https://github.com/realm/SwiftLint", stargazersCount: 18_000),
            Repository(id: 3, name: "Vapor", itemDescription: "A server-side Swift web framework", htmlURL: "https://github.com/vapor/vapor", stargazersCount: 24_000)
        ]
    }

    @Test func startsEmpty() {
        let vm = RepositoryViewModel()
        #expect(vm.repos.isEmpty)
        #expect(vm.filteredRepos.isEmpty)
        #expect(vm.searchText == "")
    }

    @Test func emptySearchReturnsAllRepos() {
        let vm = RepositoryViewModel()
        vm.repos = sampleRepos()
        #expect(vm.filteredRepos.count == 3)
    }

    @Test func searchMatchesSubstring() {
        let vm = RepositoryViewModel()
        vm.repos = sampleRepos()
        vm.searchText = "swift"
        #expect(vm.filteredRepos.contains { $0.name == "SwiftLint" })
        #expect(!vm.filteredRepos.contains { $0.name == "Alamofire" })
    }

    @Test func searchIsCaseInsensitive() {
        let vm = RepositoryViewModel()
        vm.repos = sampleRepos()
        vm.searchText = "VAPOR"
        #expect(vm.filteredRepos.count == 1)
        #expect(vm.filteredRepos.first?.name == "Vapor")
    }
}
