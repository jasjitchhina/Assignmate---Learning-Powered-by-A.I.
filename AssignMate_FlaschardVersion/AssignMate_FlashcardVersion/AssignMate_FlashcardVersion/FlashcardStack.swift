//
//  FlashcardStack.swift
//  AssignMate_FlashcardVersion
//
//  Created by Peter Borozan on 10/25/23.
//


import SwiftUI

struct FlashcardStack: View {
    var flashcards: [FlashcardData] // This array holds the flashcards to display

    @State private var currentCardIndex = 0

    var body: some View {
        VStack {
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
            } else {
                // No flashcards available
                Text("No flashcards available.")
            }
        }
    }
}

