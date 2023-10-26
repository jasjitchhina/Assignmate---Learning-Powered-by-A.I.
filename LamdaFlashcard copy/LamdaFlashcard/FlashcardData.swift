//
//  FlashcardData.swift
//  FLASHCARDS
//
//  Created by Peter Borozan on 10/23/23.
//

import Foundation

// Define a Flashcard data model
struct FlashcardData: Identifiable {
    var id = UUID()
    var front: String
    var back: String
}
