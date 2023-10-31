
import FirebaseAuth
import FirebaseFirestore
import Foundation

// A view model class for managing the new item view
class NewItemViewViewModel: ObservableObject {
    @Published var title = ""
    @Published var dueDate = Date()
    @Published var course = ""
    @Published var showAlert = false
    @Published var urgency = "Normal" // Default urgency value
    @Published var points: Int = 0
    
    init() {}
    
    // Function to save a new assignment item
    func save() {
        guard canSave else {
            return
        }
        
        // Get the current user's UID
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Create a new unique ID for the assignment item
        let newId = UUID().uuidString
        
        // Create a new assignment item model
        let newItem = AssignmentItem(
            id: newId,
            course: course,
            title: title,
            dueDate: dueDate.timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false,
            urgency: urgency, // Set urgency
            points: points   // Set points
        )
        
        // Save the new assignment item in Firestore
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("assignments")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    // Check if a new assignment item can be saved
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard !course.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        // Check if the due date is at least one day in the future
        guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }
        return true
    }
}
