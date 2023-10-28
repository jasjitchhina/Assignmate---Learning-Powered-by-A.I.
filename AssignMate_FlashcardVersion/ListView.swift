//
//  ListView.swift
//  AssignMate_FlashcardVersion
//
//  Created by Peter Borozan on 10/25/23.
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
        .task {  // Use .task instead of .onAppear for awaiting async functions
            await viewModel.loadFlashcards()
        }
    }
}


