
import FirebaseAuth
import FirebaseFirestore
import Foundation

// A view model class for managing assignment item data
class AssignmentItemViewViewModel: ObservableObject {
    
    init() {}
    
    // Function to toggle the 'isDone' property of an assignment item
    func toggleIsDone(item: AssignmentItem) {
        var itemCopy = item
        itemCopy.setDone(!item.isDone)
        
        // Get the current user's UID
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Access Firestore database
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("assignments")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary()) // Update the assignment item in Firestore
    }
    
    // Function to remove an assignment item
    func removeItem(item: AssignmentItem) {
        // Get the current user's UID
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Access Firestore database
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("assignments")
            .document(item.id)
            .delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    print("Document successfully removed!")
                }
            }
    }
}
