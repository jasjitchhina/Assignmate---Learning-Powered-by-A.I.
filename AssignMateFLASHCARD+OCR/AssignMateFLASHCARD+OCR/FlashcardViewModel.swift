//
//  FlashcardViewModel.swift
//  AssignMateFLASHCARD+OCR
//
//  Created by Peter Borozan on 10/28/23.
//

import Foundation
import SwiftUI
import Combine

// Define your view model class.
class FlashcardViewModel: ObservableObject {
    // This is your data source that the view listens to.
    @Published var flashcards: [FlashcardData] = []
    @Published var inputText: String = ""
    @Published var navigate: Bool = false
    @Published var currentFlashcardSet: FlashcardSet?

    func createFlashcardSet(from flashcards: [FlashcardData], title: String) {
        let newSet = FlashcardSet(title: title, cards: flashcards)
        self.currentFlashcardSet = newSet
    }
    
    func sendText() {
        // Here you might want to validate the input text if needed
        if !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Task {
                await loadFlashcards() // This is assuming you want to send the current inputText content to the OpenAI API.

                // Move navigation state update to the main thread
                DispatchQueue.main.async {
                    self.navigate = true
                }
            }
        }
    }

    // Your OpenAI service instance.
    private let openAI = OpenAI(apiToken: "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")

    // This function loads flashcards by making a request to the OpenAI API.
    func loadFlashcards() async {
        Task {
            do {
                // Make the request and get the response content.
                let response: String = try await requestFlashcard()
                
                // Process the response to create flashcards.
                let newFlashcards = parseResponseIntoFlashcards(response: response)

                // Update your UI on the main thread with the new flashcards.
                DispatchQueue.main.async { [weak self] in
                    self?.flashcards = newFlashcards
                }

            } catch {
                // Handle errors, e.g., from the API request.
                print("An error occurred: \(error)")
            }
        }
    }

    // This function makes an actual request to the OpenAI API.
    private func requestFlashcard() async throws -> String {
        // Prepare your query.
        let query = ChatQuery(
            model: "ft:gpt-3.5-turbo-0613:personal::8E1HWzrz",
            messages: [
                .init(role: "system", content: "You are an intelligent assistant specifically designed to help students learn more effectively. Your role is to assist in the creation of detailed and informative flashcards from the text that students provide. Analyze the submitted content, highlight key concepts, and break down information into digestible, study-friendly flashcards. Each flashcard should be in a Question and Answer format. Please format the response with two line breaks between each flashcard and one line break between each question and answer. Aim to present the material clearly and concisely, ensuring it is suitable for the student's educational level. (for example: \n\n Flashcard 1: \nQ: What is the capital of the United States? \nA: Washington D.C. \n\n Flashcard 2: \nQ: question \nA: answer \n\n)). Please format the flashcards with two line breaks between each flashcard and one line break between each question and answer."),
                .init(role: "user", content: inputText)
            ]
        )

        // Make a request to the OpenAI API and get the response.
        let result = try await openAI.chat(query: query)

        // Extract the message content safely.
        if let choice = result.choices.first {
            return choice.message.content  // Accessing the 'content' field from the 'message' object.
        } else {
            throw NSError(domain: "com.yourAppDomain.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
        }
    }


    // This function parses the OpenAI response into a flashcard format.
    private func parseResponseIntoFlashcards(response: String) -> [FlashcardData] {
        // Separate each flashcard's data.
        let flashcardBlocks = response.components(separatedBy: "\n\n")

        // Map the data to your FlashcardData structure.
        return flashcardBlocks.compactMap { block in
            // Split the content for each side of the flashcard.
            let lines = block.components(separatedBy: "\n")
            if lines.count >= 3 {
                // Extract the text for the front and back of the flashcard.
                let frontText = lines[1].replacingOccurrences(of: "Front: ", with: "")
                let backText = lines[2].replacingOccurrences(of: "Back: ", with: "")
                // Return a new FlashcardData instance.
                return FlashcardData(front: frontText, back: backText)
            }
            return nil  // Ignore any blocks that don't match the expected format.
        }
    }
}
