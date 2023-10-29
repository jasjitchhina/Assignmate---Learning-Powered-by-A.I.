//
//  SaveFlashcardsView.swift
//  AssignMateFLASHCARD+OCR
//
//  Created by Peter Borozan on 10/28/23.
//


import SwiftUI

struct SaveFlashcardsView: View {
    // Inject the store; you might want to pass it down from the parent view or use EnvironmentObject
    @ObservedObject var store: FlashcardStore

    var body: some View {
        NavigationView {
            List {
                ForEach(store.flashcardSets) { set in
                    NavigationLink(destination: FlashcardSetDetailView(flashcardSet: set)) {
                        Text(set.title)
                    }
                }
            }
            .navigationBarTitle("Your Flashcard Sets")
        }
    }
}
