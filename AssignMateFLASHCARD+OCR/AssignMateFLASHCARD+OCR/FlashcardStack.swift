//
//  FlashcardStack.swift
//  AssignMateFLASHCARD+OCR
//
//  Created by Peter Borozan on 10/28/23.
//

import SwiftUI

struct FlashcardStack: View {
    var flashcards: [FlashcardData] // This array holds the flashcards to display

    // An instance of your FlashcardStore, either passed in or created here. Ideally, you should pass it from the parent view.
    @EnvironmentObject var flashcardStore: FlashcardStore

    @State private var currentCardIndex = 0

    var body: some View {
        VStack {
            // Check if there are flashcards to display
            if !flashcards.isEmpty {
                let currentFlashcard = flashcards[currentCardIndex]

                Flashcard(front: { Text(currentFlashcard.front) }, back: { Text(currentFlashcard.back) })
                    .gesture(
                        DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                            .onEnded { value in
                                let horizontalAmount = value.translation.width as CGFloat
                                if horizontalAmount < 0 {
                                    // Swipe left: Next card
                                    if currentCardIndex < flashcards.count - 1 {
                                        currentCardIndex += 1
                                    }
                                } else {
                                    // Swipe right: Previous card
                                    if currentCardIndex > 0 {
                                        currentCardIndex -= 1
                                    }
                                }
                            }
                    )

                // Save button to store the current set of flashcards
                Button(action: {
                    // Assuming your FlashcardStore has a 'save' function
                    // Here we create a FlashcardSet from the current array of FlashcardData
                    let newSet = FlashcardSet(title: "Custom Set", cards: flashcards)
                    flashcardStore.addFlashcardSet(newSet)  // Or 'save', depending on your function's name
                }) {
                    Text("Save this set")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else {
                // No flashcards available
                Text("No flashcards available.")
            }
        }
    }
}
