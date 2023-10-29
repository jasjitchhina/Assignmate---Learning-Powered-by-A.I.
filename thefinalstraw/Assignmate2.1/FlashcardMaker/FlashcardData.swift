//
//  FlashcardData.swift
//  AssignMateFLASHCARD+OCR
//
//  Created by Peter Borozan on 10/28/23.
//

import Foundation

// Define a Flashcard data model
struct FlashcardData: Identifiable, Codable {
    var id = UUID()
    var front: String
    var back: String
}
