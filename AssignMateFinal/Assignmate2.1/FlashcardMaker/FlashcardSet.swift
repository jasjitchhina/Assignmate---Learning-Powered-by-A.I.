// Import necessary modules
import Foundation

// Define a Flashcard set data model
struct FlashcardSet: Identifiable, Codable {
    
    // Unique identifier for each flashcard set, using String data type
    var id: String  // Use String instead of UUID
    
    // Title of the flashcard set
    var title: String
    
    // Collection of flashcards within this set
    var cards: [FlashcardData]
}

