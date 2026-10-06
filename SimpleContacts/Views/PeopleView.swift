import Foundation
import SwiftUI
import SwiftData

struct PeopleView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var people: [Person]
    private let searchString: String

    var body: some View {
        List {
            ForEach(people) { person in
                NavigationLink(value: person) {
                    Text(person.name.isEmpty ? "New Person" : person.name)
                }
            }
            .onDelete(perform: deletePeople)
        }
        .overlay {
            if people.isEmpty {
                if searchString.isEmpty {
                    ContentUnavailableView(
                        "No Contacts Yet",
                        systemImage: "person.crop.circle.badge.plus",
                        description: Text("Tap + to add your first contact.")
                    )
                } else {
                    ContentUnavailableView.search(text: searchString)
                }
            }
        }
    }

    init(searchString: String = "", sortOrder: [SortDescriptor<Person>] = []) {
        self.searchString = searchString
        _people = Query(filter: #Predicate<Person> { person in
            if searchString.isEmpty {
                true
            } else {
                person.name.localizedStandardContains(searchString)
            }
        }, sort: sortOrder)
    }

    private func deletePeople(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(people[offset])
        }
    }
}
