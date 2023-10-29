import Foundation
import SwiftUI

struct FlashcardView: View {
    @ObservedObject var viewModel: FlashcardViewModel

    var body: some View {
        List(viewModel.flashcards) { flashcard in
            VStack(alignment: .leading) {
                Text(flashcard.front)
                    .font(.system(size: 24))  // Set the font size to 24
                    .bold()                   // Set the font weight to bold
                Text(flashcard.back)
                    .font(.system(size: 24))  // Set the font size to 22
                    .bold()                   // Set the font weight to bold
            }
        }
        .task {  // Use .task instead of .onAppear for awaiting async functions
            await viewModel.loadFlashcards() // No '$' before 'viewModel'
        }
    }
}
