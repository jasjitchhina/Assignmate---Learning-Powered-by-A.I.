//
//  ListView.swift
//  FLASHCARDS
//
//  Created by Peter Borozan on 10/24/23.
//

import Foundation
import SwiftUI
struct FlashcardView: View {
    @ObservedObject var viewModel: FlashcardViewModel

    var body: some View {
        List(viewModel.flashcards) { flashcard in
            VStack(alignment: .leading) {
                Text(flashcard.front)
                    .font(.headline)
                Text(flashcard.back)
                    .font(.subheadline)
            }
        }
        .onAppear {
            // Trigger your data loading function
            Task {
                await viewModel.loadFlashcards()
            }
        }
    }
}
