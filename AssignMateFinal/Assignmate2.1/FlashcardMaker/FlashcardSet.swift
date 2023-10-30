import Foundation

struct FlashcardSet: Identifiable, Codable {
    var id: String  // Use String instead of UUID
    var title: String
    var cards: [FlashcardData]
}
