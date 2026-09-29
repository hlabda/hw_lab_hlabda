import SwiftUI

struct RepositoryRow: View {
    let repo: Repository

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(repo.name).font(.headline)
            if let description = repo.itemDescription {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
                Text(repo.stargazersCount.formatted())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
