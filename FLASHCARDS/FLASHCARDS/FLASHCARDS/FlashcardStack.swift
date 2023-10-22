//
//  FlashcardStack.swift
//  FLASHCARDS
//
//  Created by Peter Borozan on 10/20/23.
//


import SwiftUI

struct FlashcardStack: View {
    @State private var flashcards: [FlashcardData] = []
    
    @State private var currentCardIndex = 0
    private var flashcardService = FlashcardService()
    private var networkManager = NetworkManager() // Initialize your NetworkManager instance
    
    var body: some View {
        VStack {
            if currentCardIndex < flashcards.count {
                let currentFlashcard = flashcards[currentCardIndex]

                Flashcard(
                    front: { Text(currentFlashcard.question) },
                    back: { Text(currentFlashcard.answer) }
                )
                // Here's the gesture for swiping
                .gesture(
                    DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                        .onEnded { [self] value in
                            // Determine the swipe direction
                            let horizontalAmount = value.translation.width as CGFloat
                            let verticalAmount = value.translation.height as CGFloat

                            if abs(horizontalAmount) > abs(verticalAmount) { // detects more horizontal swipe
                                if horizontalAmount < 0 { // left direction
                                    // Move to the next card if swiped left
                                    if currentCardIndex < flashcards.count - 1 {
                                        currentCardIndex += 1
                                    } else {
                                        // Handle the case when there are no more cards
                                        print("No more cards")
                                    }
                                }
                            }
                        }
                )
                
                // Button to trigger GPT-3.5 Turbo content generation
                Button("Generate Flashcards") {
                    // Call your NetworkManager to fetch GPT-3.5 Turbo content
                    networkManager.fetchGPTContent(prompt: "You are an intelligent assistant specifically designed to help students learn more effectively. Your role is to assist in the creation of detailed and informative flashcards from the text that students provide. You analyze the submitted content, highlight key concepts, and break down information into digestible, study-friendly flashcards in a Question and Answer format. You aim to present the material clearly and concisely, ensuring it is suitable for the student's educational level.") { result in
                        switch result {
                        case .success(let generatedContent):
                            // Update your flashcards with the generated content
                            self.updateFlashcardsWithContent(generatedContent)
                        case .failure(let error):
                            // Handle the error, e.g., show an error message to the user
                            print("Error fetching GPT content: \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                // Handle the case when there are no more cards
                Text("No more cards")
            }
        }
        .onAppear(perform: fetchFlashcards) // Apply .onAppear to the VStack
    }
    
    // Define the fetchFlashcards function outside of the body
    func fetchFlashcards() {
        flashcardService.fetchFlashcards { newCards in
            if let fetchedCards = newCards {
                self.flashcards = fetchedCards
            }
        }
    }
    
    // Function to update flashcards with generated content
    private func updateFlashcardsWithContent(_ content: String) {
        // Create a new flashcard with the generated content
        let newFlashcard = FlashcardData(question: "Generated Question", answer: content)
        
        // Append the new flashcard to your flashcards array
        flashcards.append(newFlashcard)
    }
}


