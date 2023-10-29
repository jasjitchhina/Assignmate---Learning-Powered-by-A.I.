//
//  REALContentView.swift
//  AssignMateFLASHCARD+OCR
//
//  Created by Peter Borozan on 10/28/23.
//

import SwiftUI

struct REALContentView: View {
    @StateObject private var flashcardStore = FlashcardStore()
    var body: some View {
        TabView {
            // First tab with the ScannerView
            ScannerContentView()
                .tabItem {
                    Label("Scanner", systemImage: "camera.viewfinder") // using system image, you can customize this icon
                }

            // Second tab with the MakeFlashcardsView
            MakeFlashcardsView()
                .environmentObject(flashcardStore)
                .tabItem {
                    Label("Make Flashcards", systemImage: "rectangle.and.pencil.and.ellipsis") // this is just an example, you can choose another system image
                }
            SaveFlashcardsView(store: flashcardStore)
                .tabItem {
                    Label("Your Flashcards", systemImage: "folder")
                }
        }
    }
}
        
