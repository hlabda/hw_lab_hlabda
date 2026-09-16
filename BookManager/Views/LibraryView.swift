import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var library: Library

    var body: some View {
        NavigationStack {
            List {
                ForEach(library.books) { book in
                    BookRowView(book: book)
                }
                .onDelete(perform: removeRows)
            }
            .navigationTitle("Library")
            .overlay {
                if library.books.isEmpty {
                    ContentUnavailableView(
                        "No Books",
                        systemImage: "books.vertical",
                        description: Text("Use the New Book tab to add one.")
                    )
                }
            }
            .toolbar {
                EditButton()
            }
        }
    }

    private func removeRows(at offsets: IndexSet) {
        library.removeBooks(at: offsets)
    }
}

#Preview {
    LibraryView()
        .environmentObject(Library())
}
