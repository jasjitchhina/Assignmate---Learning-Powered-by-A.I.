//
//  Flashcard.swift
//  FLASHCARDS
//
//  Created by Peter Borozan on 10/20/23.
//
import SwiftUI

struct Flashcard<Front: View, Back: View>: View {
    var front: () -> Front
    var back: () -> Back

    @State private var isFlipped = false

    var body: some View {
        let side = isFlipped ? back() as! Front : front()

        return ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white)
                .shadow(color: .gray, radius: 10, x: 0, y: 0)

            side.padding(20)
        }
        .aspectRatio(3/2, contentMode: .fit)
        .frame(width: 300, height: 200)
        .onTapGesture {
            withAnimation {
                self.isFlipped.toggle()
            }
        }
    }
}
