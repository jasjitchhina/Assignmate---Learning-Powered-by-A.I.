//
//  REALContentView.swift
//  AssignMate_FlashcardVersion
//
//  Created by Peter Borozan on 10/28/23.
//

import SwiftUI

struct REALContentView: View {
    var body: some View {
        TabView {
            // First tab with the ScannerView
            ScannerContentView()
                .tabItem {
                    Label("Scanner", systemImage: "camera.viewfinder") // using system image, you can customize this icon
                }

            // Second tab with the MakeFlashcardsView
            MakeFlashcardsView()
                .tabItem {
                    Label("Make Flashcards", systemImage: "rectangle.and.pencil.and.ellipsis") // this is just an example, you can choose another system image
                }
        }
    }
}
        
