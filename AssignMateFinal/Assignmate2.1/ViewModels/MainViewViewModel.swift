
import FirebaseAuth
import Foundation

// A view model class for managing the main view
class MainViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        // Add an authentication state change listener
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                // Update the current user's ID when the authentication state changes
                self?.currentUserId = user?.uid ?? ""
            }
        }
    }
    
    // Check if a user is signed in
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
