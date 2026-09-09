import Testing
@testable import RailsCards

struct DeckTests {
    @Test func deckHasCards() {
        let deck = Deck()
        #expect(deck.cards.count == 22)
    }

    @Test func cardsHaveCommandsAndDefinitions() {
        let deck = Deck()
        for card in deck.cards {
            #expect(!card.command.isEmpty)
            #expect(!card.definition.isEmpty)
        }
    }

    @Test func drawRandomCardReturnsCardFromDeck() {
        let deck = Deck()
        let card = deck.drawRandomCard()
        #expect(deck.cards.contains { $0.command == card.command })
    }
}
