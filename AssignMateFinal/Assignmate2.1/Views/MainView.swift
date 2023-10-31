import SwiftUI

// The main view of the application
struct MainView: View {
    // State objects and environment objects
    @StateObject private var flashcardStore = FlashcardStore()
    @StateObject var viewModel = MainViewViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        // Check if the user is signed in and the current user ID is not empty
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            accountView // Show the account view
        } else {
            LoginView() // Show the login view
        }
    }
    
    // Define the account view with tab navigation
    @ViewBuilder
    var accountView: some View {
        ZStack {
            // Set the background color based on the current color scheme
            Color("BackGroundColor").ignoresSafeArea()

            TabView {
                // Assignments view for managing assignments
                AssignmentsView(userId: viewModel.currentUserId)
                    .tabItem {
                        Label("Assignments", systemImage: "list.bullet.clipboard")
                    }
                
                // Flashcard generator view
                MakeFlashcardsView()
                    .environmentObject(flashcardStore)
                    .tabItem {
                        Label("Flashcard Generator", systemImage: "rectangle.and.pencil.and.ellipsis")
                    }
                
                // View for managing saved flashcards
                SavedFlashcardsView()
                    .environmentObject(FlashcardStore())
                    .tabItem {
                        Label("Your Flashcards", systemImage: "sparkles.rectangle.stack.fill")
                    }
                
                // User profile view
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
            }
        }
    }
}
