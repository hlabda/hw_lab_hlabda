import Foundation
import SwiftUI
import SwiftData

struct AppView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var path = [Person]()
    @State private var searchText = ""
    @State private var sortOrder = [SortDescriptor(\Person.name)]

    var body: some View {
        NavigationStack(path: $path) {
            PeopleView(searchString: searchText, sortOrder: sortOrder)
                .navigationTitle("My Contacts")
                .navigationDestination(for: Person.self) { person in
                    EditPersonView(person: person)
                }
                .toolbar {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name (A-Z)")
                                .tag([SortDescriptor(\Person.name)])
                            Text("Name (Z-A)")
                                .tag([SortDescriptor(\Person.name, order: .reverse)])
                        }
                    }
                    .accessibilityIdentifier("sortMenu")

                    Button("Add Person", systemImage: "plus", action: addPerson)
                        .accessibilityIdentifier("addPerson")
                }
                .searchable(text: $searchText, prompt: "Search contacts")
        }
    }

    private func addPerson() {
        let person = Person(name: "", email: "", details: "")
        modelContext.insert(person)
        path.append(person)
    }
}
