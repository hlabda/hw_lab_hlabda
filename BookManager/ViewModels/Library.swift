import Combine
import Foundation

final class Library: ObservableObject {
    @Published var books: [Book]

    init(books: [Book]? = nil) {
        if let books {
            self.books = books.sorted()
        } else {
            self.books = Self.seedBooks.sorted()
        }
    }

    @discardableResult
    func addBookToLibrary(
        title: String,
        author: String,
        gender: String,
        displayed: Bool
    ) -> Bool {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanTitle.isEmpty, !cleanAuthor.isEmpty else {
            return false
        }

        books.append(
            Book(
                title: cleanTitle,
                author: cleanAuthor,
                gender: gender,
                displayed: displayed
            )
        )
        books.sort()
        return true
    }

    func getBooksFor(_ author: String) -> [Book] {
        books.filter { $0.author == author }
    }

    func getFemaleAuthoredBooks() -> [Book] {
        books.filter { $0.gender == Gender.female.rawValue }
    }

    func getMaleAuthoredBooks() -> [Book] {
        books.filter { $0.gender == Gender.male.rawValue }
    }

    func removeBooks(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            books.remove(at: index)
        }
    }

    private static let seedData: [String: [String]] = [
        "The Count of Monte Cristo": ["Alexandre Dumas", "Male"],
        "The Man in the Iron Mask": ["Alexandre Dumas", "Male"],
        "The Three Musketeers": ["Alexandre Dumas", "Male"],
        "Black Beauty": ["Anna Sewell", "Female"],
        "The Tenant of Wildfell Hall": ["Anne Bronte", "Female"],
        "The Prisoner of Zenda": ["Anthony Hope", "Male"],
        "Adventures of Sherlock Holmes": ["Arthur Conan Doyle", "Male"],
        "The Hound of the Baskervilles": ["Arthur Conan Doyle", "Male"],
        "Dracula": ["Bram Stoker", "Male"],
        "A Christmas Carol": ["Charles Dickens", "Male"],
        "A Tale of Two Cities": ["Charles Dickens", "Male"],
        "David Copperfield": ["Charles Dickens", "Male"],
        "Great Expectations": ["Charles Dickens", "Male"],
        "Hard Times": ["Charles Dickens", "Male"],
        "Nicholas Nickleby": ["Charles Dickens", "Male"],
        "Oliver Twist": ["Charles Dickens", "Male"],
        "The Pickwick Papers": ["Charles Dickens", "Male"],
        "Jane Eyre": ["Charlotte Bronte", "Female"],
        "Shirley": ["Charlotte Bronte", "Female"],
        "The Professor": ["Charlotte Bronte", "Female"],
        "Villette": ["Charlotte Bronte", "Female"],
        "The Age of Innocence": ["Edith Wharton", "Female"],
        "Wuthering Heights": ["Emily Bronte", "Female"],
        "Crime and Punishment": ["Fyodor Dostoyevsky", "Male"],
        "The Brothers Karamazov": ["Fyodor Dostoyevsky", "Male"],
        "The Phantom of the Opera": ["Gaston Leroux", "Male"],
        "1984": ["George Orwell", "Male"],
        "Animal Farm": ["George Orwell", "Male"],
        "To Kill A Mockingbird": ["Harper Lee", "Female"],
        "Uncle Tom's Cabin": ["Harriet Beecher Stowe", "Female"],
        "Walden": ["Henry David Thoreau", "Male"],
        "Last of the Mohicans": ["James Fenimore Cooper", "Male"],
        "The Deerslayer": ["James Fenimore Cooper", "Male"],
        "Emma": ["Jane Austen", "Female"],
        "Mansfield Park": ["Jane Austen", "Female"],
        "Northanger Abbey": ["Jane Austen", "Female"],
        "Persuasion": ["Jane Austen", "Female"],
        "Pride and Prejudice": ["Jane Austen", "Female"],
        "Sense and Sensibility": ["Jane Austen", "Female"],
        "Pilgrim's Progress": ["John Bunyan", "Male"],
        "Of Mice and Men": ["John Steinbeck", "Male"],
        "Gulliver's Travels": ["Jonathan Swift", "Male"],
        "Around the World in Eighty Days": ["Jules Verne", "Male"],
        "Journey to the Center of the Earth": ["Jules Verne", "Male"],
        "The Awakening": ["Kate Chopin", "Female"],
        "Anna Karenina": ["Leo Tolstoy", "Male"],
        "War and Peace": ["Leo Tolstoy", "Male"],
        "Alice's Adventures in Wonderland": ["Lewis Carroll", "Male"],
        "Through The Looking Glass": ["Lewis Carroll", "Male"],
        "Little Women": ["Louisa May Alcott", "Female"],
        "Frankenstein": ["Mary Shelley", "Female"],
        "The Scarlet Letter": ["Nathaniel Hawthorne", "Male"],
        "Fahrenheit 451": ["Ray Bradbury", "Male"],
        "Kidnapped": ["Robert Louis Stevenson", "Male"],
        "The Strange Case of Dr Jekyll and Mr Hyde": ["Robert Louis Stevenson", "Male"],
        "Treasure Island": ["Robert Louis Stevenson", "Male"],
        "The Red Badge of Courage": ["Stephen Crane", "Male"],
        "Rights of Man": ["Thomas Paine", "Male"],
        "Les Miserables": ["Victor Hugo", "Male"],
        "A Midsummer Night's Dream": ["William Shakespeare", "Male"],
        "Hamlet": ["William Shakespeare", "Male"],
        "Henry V": ["William Shakespeare", "Male"],
        "Julius Caesar": ["William Shakespeare", "Male"],
        "King Lear": ["William Shakespeare", "Male"],
        "Macbeth": ["William Shakespeare", "Male"],
        "Much Ado About Nothing": ["William Shakespeare", "Male"],
        "Othello": ["William Shakespeare", "Male"],
        "Romeo and Juliet": ["William Shakespeare", "Male"],
        "The Comedy of Errors": ["William Shakespeare", "Male"],
        "The Merchant of Venice": ["William Shakespeare", "Male"],
        "The Taming of the Shrew": ["William Shakespeare", "Male"],
        "The Tempest": ["William Shakespeare", "Male"],
        "Twelfth Night": ["William Shakespeare", "Male"],
        "The Hobbit or There and Back Again": ["J.R.R. Tolkien", "Male"],
        "The Fellowship of the Ring": ["J.R.R. Tolkien", "Male"],
        "The Two Towers": ["J.R.R. Tolkien", "Male"],
        "The Return of the King": ["J.R.R. Tolkien", "Male"]
    ]

    private static var seedBooks: [Book] {
        seedData.compactMap { title, details in
            guard details.count == 2 else { return nil }
            return Book(
                title: title,
                author: details[0],
                gender: details[1],
                displayed: true
            )
        }
    }
}
