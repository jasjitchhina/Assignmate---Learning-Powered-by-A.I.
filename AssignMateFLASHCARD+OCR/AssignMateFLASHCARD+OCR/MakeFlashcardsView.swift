//
//  MakeFlashcardsView.swift
//  AssignMateFLASHCARD+OCR
//
//  Created by Peter Borozan on 10/28/23.
//

import SwiftUI

struct MakeFlashcardsView: View {
    @StateObject private var viewModel = FlashcardViewModel()
    @State private var isNavigationActive = false  // <-- Here
    @EnvironmentObject var flashcardStore: FlashcardStore

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter text here", text: $viewModel.inputText)
                    .padding()
                    .textFieldStyle(.roundedBorder)

                // The button now directly handles the action.
                Button(action: {
                    viewModel.sendText()
                    if let newSet = viewModel.currentFlashcardSet {
                        flashcardStore.addFlashcardSet(newSet)
                    }
                    isNavigationActive = true  // Trigger the navigation.
                }) {
                    Text("Enter")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                // The NavigationLink is now invisible and is just used to handle the navigation.
                NavigationLink(
                    destination: FlashcardContentView(viewModel: viewModel),
                    isActive: $isNavigationActive,  // <-- Here
                    label: {
                        EmptyView()  // It doesn't display anything itself.
                    }
                )
            }
            .navigationBarTitle("Make Flashcards", displayMode: .inline)
            .padding()
        }
    }
}
