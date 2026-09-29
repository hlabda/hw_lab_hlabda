import Foundation

nonisolated struct Repository: Codable, Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let itemDescription: String?
    let htmlURL: String
    let stargazersCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case itemDescription = "description"
        case htmlURL = "html_url"
        case stargazersCount = "stargazers_count"
    }
}
