import FirebaseFirestore
import FirebaseAuth
import Foundation

// Observable class that manages and stores Flashcard sets
class FlashcardStore: ObservableObject {
    // An array of flashcard sets that's observed for UI updates
    @Published var flashcardSets: [FlashcardSet] = []
    
    // Computed property to get the current user's ID from FirebaseAuth
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    // Instance of Firestore database
    let db = Firestore.firestore()

    // Initializer fetches flashcard sets for the user on class instantiation
    init() {
        fetchFlashcardSets()
    }

    // Fetches the flashcard sets from Firestore for the authenticated user
    func fetchFlashcardSets() {
        guard let userId = userId else {
            print("Error: No authenticated user found.")
            return
        }
        
        // Snapshot listener for real-time updates from Firestore
        db.collection("users").document(userId).collection("flashcardSets").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            // Mapping Firestore documents to FlashcardSet model
            self.flashcardSets = documents.compactMap { (queryDocumentSnapshot) -> FlashcardSet? in
                let data = queryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""

                let cardsData = data["cards"] as? [[String: String]] ?? []
                let cards = cardsData.map { FlashcardData(front: $0["front"] ?? "", back: $0["back"] ?? "") }

                return FlashcardSet(id: queryDocumentSnapshot.documentID, title: title, cards: cards)
            }
        }
    }

    // Adds a flashcard set to Firestore for the authenticated user
    func addFlashcardSet(_ flashcardSet: FlashcardSet) {
        guard let userId = self.userId else {
            print("Error: No authenticated user found.")
            return
        }
        
        // Add the flashcard set to Firestore and handle success/error response
        var ref: DocumentReference? = nil
        ref = db.collection("users").document(userId).collection("flashcardSets").addDocument(data: [
            "title": flashcardSet.title,
            "cards": flashcardSet.cards.map { ["front": $0.front, "back": $0.back] }
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    // Deletes a flashcard set from Firestore for a specific user
    func deleteFlashcardSet(set: FlashcardSet, for userId: String) {
        // Get the Firestore reference for the flashcard set to delete
        let ref = db.collection("users").document(userId).collection("flashcardSets").document(set.id)
        ref.delete { (error) in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                // If successfully deleted from Firestore, also remove it from the local array
                if let index = self.flashcardSets.firstIndex(where: { $0.id == set.id }) {
                    self.flashcardSets.remove(at: index)
                }
                print("Document successfully deleted!")
            }
        }
    }
    
    // Update the title of a flashcard set in Firestore for a specific user
    func updateFlashcardSetTitle(id: String, newTitle: String, for userId: String) {
        // Get the Firestore reference for the flashcard set to update
        let ref = db.collection("users").document(userId).collection("flashcardSets").document(id)
        ref.updateData(["title": newTitle]) { (error) in
            if let error = error {
                print("Error updating title: \(error)")
            } else {
                // If title is successfully updated in Firestore, also update it in the local array
                if let index = self.flashcardSets.firstIndex(where: { $0.id == id }) {
                    self.flashcardSets[index].title = newTitle
                }
                print("Title successfully updated!")
            }
        }
    }
}
