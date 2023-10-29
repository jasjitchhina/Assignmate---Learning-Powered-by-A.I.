import SwiftUI

struct MakeFlashcardsView: View {
    @StateObject private var viewModel = FlashcardViewModel()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter text here", text: $viewModel.inputText)
                    .padding()
                    .textFieldStyle(.roundedBorder)

                // Here, NavigationLink directly wraps the Button, and we trigger the viewModel's sendText function when the button is tapped.
                NavigationLink(destination: FlashcardContentView(viewModel: viewModel)) {
                    Button(action: {}) { // The action is empty because it's now handled by the NavigationLink
                        Text("Enter")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .simultaneousGesture(TapGesture().onEnded{
                    viewModel.sendText() // Trigger the text sending when the button is tapped.
                })
            }
            .navigationBarTitle("Make Flashcards", displayMode: .inline)
            .padding()
        }
    }
}
