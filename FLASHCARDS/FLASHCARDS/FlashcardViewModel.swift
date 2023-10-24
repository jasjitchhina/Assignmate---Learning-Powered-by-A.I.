//
//  FlashcardViewModel.swift
//  FLASHCARDS
//
//  Created by Peter Borozan on 10/23/23.
//

import Foundation
import SwiftUI
import Combine


// Define your view model class.
class FlashcardViewModel: ObservableObject {
    // This is your data source that the view listens to.
    @Published var flashcards: [FlashcardData] = []
    
    // Your OpenAI service instance would be here.
    // Note: You need to define 'OpenAIService' and replace 'YourAPITokenHere' with your actual API token.
    private let openAI = OpenAI(apiToken: "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")

    // This function loads flashcards by making a request to the OpenAI API.
    func loadFlashcards() async {
        do {
            let response = result["choices"][0]["message"]["content"]/* your response string here, the one with "Flashcard 1:\nFront: ..." etc. */
            
            // Separate each flashcard's data
            let flashcardBlocks = response.components(separatedBy: "\n\n")
            
            // Temporary array to hold parsed flashcards
            var newFlashcards: [FlashcardData] = []

            for block in flashcardBlocks {
                // Split the content for each side of the flashcard
                let lines = block.components(separatedBy: "\n")
                if lines.count >= 3 {
                    // Assuming the format is always correct and consistent in your response
                    let frontText = lines[1].replacingOccurrences(of: "Front: ", with: "")
                    let backText = lines[2].replacingOccurrences(of: "Back: ", with: "")

                    newFlashcards.append(FlashcardData(front: frontText, back: backText))
                }
            }

            // Now, update your UI on the main thread with the new flashcards
            DispatchQueue.main.async { [weak self] in
                self?.flashcards = newFlashcards
            }

        } catch {
            // Handle errors
            print("Failed to parse flashcards: \(error)")
        }
    }




    // This function makes an actual request to the OpenAI API.
     private func requestFlashcard() async throws -> String {
        // Prepare your query.
        let query = ChatQuery(
            model: "ft:gpt-3.5-turbo-0613:personal::8BNCq0xA",
            messages: [
                .init(role: "system", content: "You are an intelligent assistant specifically designed to help students learn more effectively. Your role is to assist in the creation of detailed and informative flashcards from the text that students provide."),
                .init(role: "user", content: "Einstein's theory of relativity")
            ]
        )

        // Make a request to the OpenAI API and get the response.
        let result = try await openAI.chat(query: query)

        // If there's no data, throw an error.
        guard let text = result.choices.first?.data.text else {
            throw NSError(domain: "com.yourAppDomain.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
        }
        return text
    }
}

// Don't forget to define your 'OpenAIService' with a 'chat' method that performs the network request.






























