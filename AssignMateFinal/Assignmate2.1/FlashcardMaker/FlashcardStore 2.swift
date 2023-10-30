import FirebaseFirestore
import FirebaseAuth
import Foundation

class FlashcardStore: ObservableObject {
    @Published var flashcardSets: [FlashcardSet] = []
    
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    let db = Firestore.firestore()

    init() {
        fetchFlashcardSets()
    }

    func fetchFlashcardSets() {
        guard let userId = userId else {
            print("Error: No authenticated user found.")
            return
        }
        
        db.collection("users").document(userId).collection("flashcardSets").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.flashcardSets = documents.compactMap { (queryDocumentSnapshot) -> FlashcardSet? in
                let data = queryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""

                let cardsData = data["cards"] as? [[String: String]] ?? []
                let cards = cardsData.map { FlashcardData(front: $0["front"] ?? "", back: $0["back"] ?? "") }

                return FlashcardSet(id: queryDocumentSnapshot.documentID, title: title, cards: cards)
            }
        }
    }

    func addFlashcardSet(_ flashcardSet: FlashcardSet) {
        guard let userId = self.userId else {
            print("Error: No authenticated user found.")
            return
        }
        
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
    
    func deleteFlashcardSet(set: FlashcardSet, for userId: String) {
        // Delete from Firestore
        let ref = db.collection("users").document(userId).collection("flashcardSets").document(set.id)
        ref.delete { (error) in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                // Remove from local array
                if let index = self.flashcardSets.firstIndex(where: { $0.id == set.id }) {
                    self.flashcardSets.remove(at: index)
                }
                print("Document successfully deleted!")
            }
        }
    }
    func updateFlashcardSetTitle(id: String, newTitle: String, for userId: String) {
        // Update Firestore
        let ref = db.collection("users").document(userId).collection("flashcardSets").document(id)
        ref.updateData(["title": newTitle]) { (error) in
            if let error = error {
                print("Error updating title: \(error)")
            } else {
                // Update local array
                if let index = self.flashcardSets.firstIndex(where: { $0.id == id }) {
                    self.flashcardSets[index].title = newTitle
                }
                print("Title successfully updated!")
            }
        }
    }

}
