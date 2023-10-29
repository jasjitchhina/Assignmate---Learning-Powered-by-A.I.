//
//  Flashcard.swift
//  AssignMateFLASHCARD+OCR
//
//  Created by Peter Borozan on 10/28/23.
//

import Foundation
import SwiftUI

struct Flashcard<Front: View, Back: View>: View {
    var front: () -> Front
    var back: () -> Back

    @State private var isFlipped = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let side = isFlipped ? back() as! Front : front()
        let cardColor: Color = (colorScheme == .dark) ? Color.black.opacity(0.9) : Color.white
        let shadowColor: Color = (colorScheme == .dark) ? Color.black.opacity(0.7) : Color.gray

        return ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(cardColor)
                .shadow(color: shadowColor, radius: 10, x: 0, y: 0)

            side.padding(20)
        }
        .aspectRatio(3/2, contentMode: .fit)
        .rotationEffect(.degrees(90))
        .frame(width: 450, height: 350)
        .onTapGesture {
            withAnimation {
                self.isFlipped.toggle()
            }
        }
    }
}
