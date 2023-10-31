import FirebaseAuth
import Firebase
import FirebaseFirestore
import Foundation
import SwiftUI
import Combine
import OpenAI

// This ViewModel is responsible for handling business logic related to flashcards.
class FlashcardViewModel: ObservableObject {
    // These properties will be observed by the SwiftUI view for changes.
    @Published var flashcards: [FlashcardData] = []       // List of flashcards generated from the input text.
    @Published var inputText: String = ""                 // User's input text from which flashcards are generated.
    @Published var navigate: Bool = false                 // Navigation flag, possibly for navigating to a new screen/view.
    @Published var currentFlashcardSet: FlashcardSet?     // Holds the current set of flashcards.
    @Published var isLoading: Bool = true                 // Reflects the loading state for asynchronous operations.

    private var db = Firestore.firestore()                // Firestore database instance.

    // Creates a new flashcard set from provided flashcards and title.
    func createFlashcardSet(from flashcards: [FlashcardData], title: String) {
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            print("Error: userId is nil or empty.")
            return
        }

        let id = UUID().uuidString
        let newSet = FlashcardSet(id: id, title: title, cards: flashcards)
        self.currentFlashcardSet = newSet
        
        // Persist the flashcard set to Firebase.
        saveFlashcardSetToFirebase(flashcardSet: newSet, userId: userId)
    }

    // Method to reset the navigation flag.
    func resetNavigation() {
        navigate = false
    }

    // Triggers the process of generating flashcards from the input text.
    func sendText() {
        if !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Task {
                await loadFlashcards()
            }
        }
    }

    private let openAI = OpenAI(apiToken: "insert secret key")

    // Load flashcards from OpenAI based on the input text.
    func loadFlashcards() async {
        do {
            // Indicate loading state to UI.
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = true
            }

            let response: String = try await requestFlashcard()
            let newFlashcards = parseResponseIntoFlashcards(response: response)

            // Update UI properties on the main thread after processing is complete.
            DispatchQueue.main.async { [weak self] in
                self?.flashcards = newFlashcards
                self?.isLoading = false
                self?.navigate = true  // Trigger navigation after loading.
            }
        } catch {
            print("An error occurred: \(error)")
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
            }
        }
    }

    // Sends a chat request to OpenAI and gets back a response in flashcard format.
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

    // Parse the response from OpenAI into individual flashcards.
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

    // Persists the provided flashcard set to Firestore.
    private func saveFlashcardSetToFirebase(flashcardSet: FlashcardSet, userId: String) {
        let id = UUID().uuidString
        let setData: [String: Any] = [
            "id": flashcardSet.id,
            "title": flashcardSet.title,
            "cards": flashcardSet.cards.map { [
                "front": $0.front,
                "back": $0.back
            ] }
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
