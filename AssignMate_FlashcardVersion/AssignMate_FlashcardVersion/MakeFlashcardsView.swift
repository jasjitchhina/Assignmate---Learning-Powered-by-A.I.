//
//  MakeFlashcardsView.swift
//  AssignMate_FlashcardVersion
//
//  Created by Peter Borozan on 10/28/23.
//

import SwiftUI

struct MakeFlashcardsView: View {
    // Instantiate the view model
    @StateObject private var viewModel = FlashcardViewModel()

    var body: some View {
        VStack {
            // Text field for the user's input
            TextField("Enter text here", text: $viewModel.inputText)
                .padding() // To make it look a bit nicer
                .textFieldStyle(.roundedBorder) // Example style, you can use another
            
            // Button to send the text
            Button(action: {
                // Action to send text
                viewModel.sendText()
            }) {
                Text("Enter") // Button's label
                    .padding()
                    .background(Color.blue) // Example color, you can customize this
                    .foregroundColor(.white)
                    .cornerRadius(8) // Optional rounded corners for aesthetics
            }
        }
        .padding() // Add padding to the VStack
    }
}
