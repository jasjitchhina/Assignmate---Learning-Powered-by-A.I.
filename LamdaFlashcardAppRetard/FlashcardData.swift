//
//  FlashcardData.swift
//  LamdaFlashcard
//
//  Created by Peter Borozan on 10/25/23.
//


import Foundation

// Define a Flashcard data model
struct FlashcardData: Identifiable {
    var id = UUID()
    var front: String
    var back: String
}
