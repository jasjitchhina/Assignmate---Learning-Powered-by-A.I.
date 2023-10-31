
import FirebaseFirestore
import Foundation

// A view model class for managing a list of assignments
class AssignmentsViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    
    private let userId: String
    
    init(userId: String) {
        self.userId =  userId
    }
    
    /// Delete an assignment item
    /// - Parameter id: The ID of the item to delete
    func delete(id: String) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("assignments")
            .document(id)
            .delete() // Delete the assignment item from Firestore
    }
}
