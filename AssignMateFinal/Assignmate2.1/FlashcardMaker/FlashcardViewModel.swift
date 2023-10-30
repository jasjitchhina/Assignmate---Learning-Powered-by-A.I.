import FirebaseAuth
import Firebase
import FirebaseFirestore
import Foundation
import SwiftUI
import Combine
import OpenAI

class FlashcardViewModel: ObservableObject {
    @Published var flashcards: [FlashcardData] = []
    @Published var inputText: String = ""
    @Published var navigate: Bool = false
    @Published var currentFlashcardSet: FlashcardSet?
    @Published var isLoading: Bool = true  // Reflect loading state

    
    private var db = Firestore.firestore()

    func createFlashcardSet(from flashcards: [FlashcardData], title: String) {
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            print("Error: userId is nil or empty.")
            return
        }
        
        
        // Generating a UUID for the new flashcard set
        let id = UUID().uuidString

        // Creating a new flashcard set with the generated UUID
        let newSet = FlashcardSet(id: id, title: title, cards: flashcards)
        self.currentFlashcardSet = newSet
        
        // Save this flashcard set to Firebase
        saveFlashcardSetToFirebase(flashcardSet: newSet, userId: userId)
    }
    
    func resetNavigation() {
        navigate = false
    }
    func sendText() {
        if !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Task {
                await loadFlashcards()
            }
        }
    }


    private let openAI = OpenAI(apiToken: "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")
    
    func loadFlashcards() async {
        do {
            // Set isLoading on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = true
            }

            let response: String = try await requestFlashcard()
            let newFlashcards = parseResponseIntoFlashcards(response: response)

            // Update UI-related properties on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.flashcards = newFlashcards
                self?.isLoading = false
                self?.navigate = true  // Navigate after loading
            }
        } catch {
            print("An error occurred: \(error)")
            
            // Handle error and update UI on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                // Additionally, consider updating some error state property here
            }
        }
    }
    private func requestFlashcard() async throws -> String {
        let query = ChatQuery(
            model: "ft:gpt-3.5-turbo-0613:personal::8E1HWzrz",
            messages: [
                .init(role: "system", content: "You are an intelligent assistant specifically designed to help students learn more effectively. Your role is to assist in the creation of detailed and informative flashcards from the text that students provide. Analyze the submitted content, highlight key concepts, and break down information into digestible, study-friendly flashcards. Each flashcard should be in a Question and Answer format. Please format the response with two line breaks between each flashcard and one line break between each question and answer. Aim to present the material clearly and concisely, ensuring it is suitable for the student's educational level. (for example: \n\n Flashcard 1: \nQ: What is the capital of the United States? \nA: Washington D.C. \n\n Flashcard 2: \nQ: question \nA: answer \n\n)."),
                .init(role: "user", content: inputText)
            ]
        )

        let result = try await openAI.chat(query: query)
        if let choice = result.choices.first {
            return choice.message.content
        } else {
            throw NSError(domain: "com.yourAppDomain.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
        }
    }

    private func parseResponseIntoFlashcards(response: String) -> [FlashcardData] {
        let flashcardBlocks = response.components(separatedBy: "\n\n")
        return flashcardBlocks.compactMap { block in
            let lines = block.components(separatedBy: "\n")
            if lines.count >= 3 {
                let frontText = lines[1].replacingOccurrences(of: "Q: ", with: "")
                let backText = lines[2].replacingOccurrences(of: "A: ", with: "")
                return FlashcardData(front: frontText, back: backText)
            }
            return nil
        }
    }
    
    private func saveFlashcardSetToFirebase(flashcardSet: FlashcardSet, userId: String) {
        // Generating a unique ID for the flashcard set
        let id = UUID().uuidString

        // Convert your flashcard set to dictionary for Firestore
        let setData: [String: Any] = [
            "id": id,
            "title": flashcardSet.title,
            "cards": flashcardSet.cards.map { ["front": $0.front, "back": $0.back] }
        ]

        db.collection("users").document(userId).collection("flashcardSets").addDocument(data: setData) { error in
            if let e = error {
                print("There was an issue saving data to Firestore: \(e)")
            } else {
                print("Successfully saved data!")
            }
        }
    }
}
