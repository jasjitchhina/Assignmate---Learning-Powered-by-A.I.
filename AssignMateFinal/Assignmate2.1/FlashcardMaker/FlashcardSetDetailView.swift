
// Import necessary modules
import SwiftUI

// Define a view for displaying details of a flashcard set
struct FlashcardSetDetailView: View {
    // The specific flashcard set to be displayed
    var flashcardSet: FlashcardSet

    // Body of the view
    var body: some View {
        // Create a list of cards in the flashcard set
        List(flashcardSet.cards) { card in
            // Vertically stack each card's front and back content
            VStack(alignment: .leading) {
                // Display the front content of the card with a specific font size
                Text(card.front)
                    .font(.system(size: 40))
                // Display the back content of the card with a specific font size
                Text(card.back)
                    .font(.system(size: 40))
            }
        }
        // Set the title for the navigation bar to the title of the flashcard set
        .navigationBarTitle(flashcardSet.title)
    }
}
