// Import necessary modules
import Foundation

// Define a Flashcard data model
struct FlashcardData: Identifiable, Codable {
    
    // Unique identifier for each flashcard, generated using UUID
    var id = UUID()
    
    // Text content for the front side of the flashcard
    var front: String
    
    // Text content for the back side of the flashcard
    var back: String
}
