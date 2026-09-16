import SwiftUI

struct NewBookView: View {
    @EnvironmentObject private var library: Library

    @State private var title = ""
    @State private var author = ""
    @State private var gender = Gender.male.rawValue
    @State private var displayed = false
    @State private var showingConfirmation = false

    private var hasRequiredFields: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Book Information") {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.words)

                    TextField("Author", text: $author)
                        .textInputAutocapitalization(.words)
                }

                Section("Author") {
                    Picker("Author Gender", selection: $gender) {
                        ForEach(Gender.allGenders, id: \.self) { gender in
                            Text(gender).tag(gender)
                        }
                    }
                }

                Section {
                    Toggle("Display book in library", isOn: $displayed)
                }

                if hasRequiredFields {
                    Section {
                        Button(action: addBook) {
                            Label("Add Book", systemImage: "plus.circle.fill")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.bold)
                        }
                    }
                }
            }
            .navigationTitle("New Book")
            .alert("Book Added", isPresented: $showingConfirmation) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("The book was added to your library.")
            }
        }
    }

    private func addBook() {
        guard library.addBookToLibrary(
            title: title,
            author: author,
            gender: gender,
            displayed: displayed
        ) else { return }

        title = ""
        author = ""
        gender = Gender.male.rawValue
        displayed = false
        showingConfirmation = true
    }
}

#Preview {
    NewBookView()
        .environmentObject(Library())
}
