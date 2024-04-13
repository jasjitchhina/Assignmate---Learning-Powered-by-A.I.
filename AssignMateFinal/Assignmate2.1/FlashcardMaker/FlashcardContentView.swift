import SwiftUI

struct FlashcardContentView: View {
    @StateObject var viewModel = FlashcardViewModel() // ViewModel is observed by the ContentView

    var body: some View {
        VStack {
            if viewModel.flashcards.isEmpty {
                Text("Loading...")
                    .onAppear {
                        Task {
                            await viewModel.loadFlashcards() // Fetch flashcards when the view appears
                        }
                    }
            } else {
                FlashcardStack(flashcards: viewModel.flashcards) // Your existing FlashcardStack view
            }
        }
    }
}
