import Testing
import Foundation
import SwiftData
@testable import SimpleContacts

@MainActor
struct PersonTests {
    private func makeInMemoryContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: Person.self, configurations: config)
    }

    @Test func personInitializesWithDefaults() {
        let person = Person(name: "Alex Heimann", email: "alex@example.com", details: "Friend")
        #expect(person.name == "Alex Heimann")
        #expect(person.email == "alex@example.com")
        #expect(person.details == "Friend")
        #expect(person.photo == nil)
    }

    @Test func insertingPersistsInContext() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        context.insert(Person(name: "An Heimann", email: "an@example.com", details: "Wife"))
        try context.save()
        let all = try context.fetch(FetchDescriptor<Person>())
        #expect(all.count == 1)
        #expect(all.first?.name == "An Heimann")
    }

    @Test func deleteRemovesFromContext() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        let person = Person(name: "Tim Daigle", email: "tim@example.com", details: "")
        context.insert(person)
        try context.save()
        context.delete(person)
        try context.save()
        #expect(try context.fetch(FetchDescriptor<Person>()).isEmpty)
    }

    @Test func sortDescriptorOrdersByName() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        for name in ["Tom Brady", "Alex Heimann", "Tim Daigle"] {
            context.insert(Person(name: name, email: "", details: ""))
        }
        try context.save()
        let descriptor = FetchDescriptor<Person>(sortBy: [SortDescriptor(\.name)])
        #expect(try context.fetch(descriptor).map(\.name) == ["Alex Heimann", "Tim Daigle", "Tom Brady"])
    }

    @Test func searchPredicateMatchesSubstring() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        for name in ["Alex Heimann", "An Heimann", "Tom Brady"] {
            context.insert(Person(name: name, email: "", details: ""))
        }
        try context.save()
        let needle = "heim"
        let descriptor = FetchDescriptor<Person>(
            predicate: #Predicate { $0.name.localizedStandardContains(needle) }
        )
        let matches = try context.fetch(descriptor)
        #expect(matches.count == 2)
        #expect(matches.allSatisfy { $0.name.localizedStandardContains("heim") })
    }

    @Test func reverseSortOrdersByName() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        for name in ["Alex Heimann", "Tom Brady", "Tim Daigle"] {
            context.insert(Person(name: name, email: "", details: ""))
        }
        try context.save()
        let descriptor = FetchDescriptor<Person>(sortBy: [SortDescriptor(\.name, order: .reverse)])
        #expect(try context.fetch(descriptor).map(\.name) == ["Tom Brady", "Tim Daigle", "Alex Heimann"])
    }

    @Test func editsAndPhotoPersistAcrossContexts() throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        let person = Person(name: "Alex", email: "", details: "")
        context.insert(person)
        try context.save()
        person.name = "Alex Heimann"
        person.email = "alex@example.com"
        person.details = "Updated contact"
        person.photo = Data([0x01, 0x02, 0x03])
        try context.save()

        let freshContext = ModelContext(container)
        let saved = try #require(freshContext.fetch(FetchDescriptor<Person>()).first)
        #expect(saved.name == "Alex Heimann")
        #expect(saved.email == "alex@example.com")
        #expect(saved.details == "Updated contact")
        #expect(saved.photo == Data([0x01, 0x02, 0x03]))
    }
}
