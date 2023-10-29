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
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            accountView
        } else{
            LoginView()
        }
    }
    
    @ViewBuilder
    var accountView: some View{
        TabView {
            AssignmentsView(userId: viewModel.currentUserId)
                .tabItem{
                    Label("Assignments", systemImage: "list.bullet.clipboard")
                }
            MakeFlashcardsView()
                .environmentObject(flashcardStore)
                .tabItem {
                    Label("Make Flashcards", systemImage: "rectangle.and.pencil.and.ellipsis") // this is just an example, you can choose another system image
                }
            SavedFlashcardsView()
                .environmentObject(FlashcardStore())
                .tabItem {
                    Label("Your Flashcards", systemImage: "folder")  // Assuming you want to keep the same tab icon
                }
            ProfileView()
                .tabItem{
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainView()
}
