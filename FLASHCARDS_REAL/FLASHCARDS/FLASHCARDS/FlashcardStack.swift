//
//  FlashcardStack.swift
//  FLASHCARDS
//
//  Created by Peter Borozan on 10/20/23.
//

import SwiftUI

struct FlashcardStack: View {
    // Populate your flashcards array with some initial data
    @State private var flashcards: [FlashcardData] = [
        FlashcardData(question: "What is the capital of France?", answer: "Paris"),
        FlashcardData(question: "Who developed the theory of relativity?", answer: "Albert Einstein"),
        // You can add more flashcards here...
    ]

    @State private var currentCardIndex = 0

    var body: some View {
        VStack {
            // Check if there are any cards to display
            if !flashcards.isEmpty {
                let currentFlashcard = flashcards[currentCardIndex]

                Flashcard(
                    front: { Text(currentFlashcard.question) },
                    back: { Text(currentFlashcard.answer) }
                )
                .frame(width: 300, height: 400)  // Or any other value suitable for your design
                .gesture(
                    DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                        .onEnded { value in
                            let horizontalAmount = value.translation.width as CGFloat
                            let verticalAmount = value.translation.height as CGFloat

                            if abs(horizontalAmount) > abs(verticalAmount) {
                                // Swiping horizontally
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
                        }
                )
            } else {
                // If there are no flashcards, display a message
                Text("No flashcards available.")
            }
        }
        .padding()  // Ensure there's some space around the VStack
    }
}
