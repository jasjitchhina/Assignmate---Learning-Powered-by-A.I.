//
//  ContentView.swift
//  AssignMate
//
//  Created by Jesse Chhina on 10/13/23.
//

import SwiftUI

struct MainView: View {
    @StateObject private var flashcardStore = FlashcardStore()
    @StateObject var viewModel = MainViewViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            accountView
        } else{
            LoginView()
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        ZStack {
            // This will automatically pick the right color based on the current color scheme
            Color("BackGroundColor").ignoresSafeArea()

            TabView {
                AssignmentsView(userId: viewModel.currentUserId)
                    .tabItem{
                        Label("Assignments", systemImage: "list.bullet.clipboard")
                    }
                MakeFlashcardsView()
                    .environmentObject(flashcardStore)
                    .tabItem {
                        Label("Flashcard Generator", systemImage: "rectangle.and.pencil.and.ellipsis")
                    }
                SavedFlashcardsView()
                    .environmentObject(FlashcardStore())
                    .tabItem {
                        Label("Your Flashcards", systemImage: "sparkles.rectangle.stack.fill")
                    }
                ProfileView()
                    .tabItem{
                        Label("Profile", systemImage: "person.circle")
                    }
            
            }
        }
    }

}
