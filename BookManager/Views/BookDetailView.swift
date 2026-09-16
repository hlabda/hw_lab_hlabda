import SwiftUI

struct BookDetailView: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(book.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Label(book.author, systemImage: "person.fill")
                .font(.title3)
                .fontWeight(.semibold)

            Label(book.gender, systemImage: "person.2.fill")
                .font(.headline)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationTitle("Book Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BookDetailView(
            book: Book(
                title: "Pride and Prejudice",
                author: "Jane Austen",
                gender: "Female",
                displayed: true
            )
        )
    }
}
