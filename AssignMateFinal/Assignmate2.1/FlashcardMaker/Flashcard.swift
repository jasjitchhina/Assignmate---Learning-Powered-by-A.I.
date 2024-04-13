import Foundation
import SwiftUI

struct Flashcard<Front: View, Back: View>: View {
    var front: () -> Front
    var back: () -> Back

    @State private var isFlipped = false

    var body: some View {
        let side = isFlipped ? back() as! Front : front()

        return ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.white)
                .shadow(color: .gray, radius: 10, x: 0, y: 0)

            side.padding(20)
        }
        .aspectRatio(3/2, contentMode: .fit)
        .rotationEffect(.degrees(90))
        .frame(width: 400, height: 300)
        .onTapGesture {
            withAnimation {
                self.isFlipped.toggle()
            }
        }
    }
}
