//
//  FlashcardSet.swift
//  AssignMateFLASHCARD+OCR
//
//  Created by Peter Borozan on 10/28/23.
//

import Foundation

struct FlashcardSet: Identifiable {
    var id = UUID()
    var title: String
    var cards: [FlashcardData]
}
