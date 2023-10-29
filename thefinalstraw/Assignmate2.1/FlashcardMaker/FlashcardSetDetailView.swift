//
//  FlashcardSetDetailView.swift
//  AssignMateFLASHCARD+OCR
//
//  Created by Peter Borozan on 10/28/23.
//

// FlashcardSetDetailView.swift

import SwiftUI

struct FlashcardSetDetailView: View {
    var flashcardSet: FlashcardSet

    var body: some View {
        List(flashcardSet.cards) { card in
            VStack(alignment: .leading) {
                Text(card.front)
                    .font(.headline)
                Text(card.back)
                    .font(.subheadline)
            }
        }
        .navigationBarTitle(flashcardSet.title)

    }
}
