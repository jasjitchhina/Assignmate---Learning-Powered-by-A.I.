
import FirebaseAuth
import FirebaseFirestore
import Foundation

// A view model class for managing the user profile view
class ProfileViewViewModel: ObservableObject {
    init() {}
    
    @Published var user: User? = nil
    
    // Function to fetch user data
    func fetchUser() {
        // Get the current user's UID
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Access Firestore database
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                // Create a user object with fetched data
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0
                )
            }
        }
    }
    
    // Function to log out the current user
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}
