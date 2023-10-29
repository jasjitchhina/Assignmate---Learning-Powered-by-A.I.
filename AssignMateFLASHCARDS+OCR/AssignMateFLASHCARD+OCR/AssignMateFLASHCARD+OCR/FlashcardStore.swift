//
//  FlashcardStore.swift
//  AssignMateFLASHCARD+OCR
//
//  Created by Peter Borozan on 10/28/23.
//

// FlashcardStore.swift

import Foundation

class FlashcardStore: ObservableObject {
    @Published var flashcardSets: [FlashcardSet] = []

    // Function to add a new flashcard set
    func addFlashcardSet(_ flashcardSet: FlashcardSet) {
        flashcardSets.append(flashcardSet)
        // Here, you might also want to save the new set to persistent storage.
    }

    // ... any other functionality you need, like removing sets, saving to disk, etc.
}
