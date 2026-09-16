import SwiftUI

struct BookRowView: View {
    let book: Book

    var body: some View {
        NavigationLink {
            BookDetailView(book: book)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.body)
                    .fontWeight(.semibold)

                Text(book.author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 3)
        }
    }
}

#Preview {
    NavigationStack {
        List {
            BookRowView(
                book: Book(
                    title: "Pride and Prejudice",
                    author: "Jane Austen",
                    gender: "Female",
                    displayed: true
                )
            )
        }
    }
}
