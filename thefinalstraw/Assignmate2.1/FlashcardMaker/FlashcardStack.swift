import FirebaseFirestore
import FirebaseAuth
import SwiftUI

struct FlashcardStack: View {
    var flashcards: [FlashcardData]

    @EnvironmentObject var flashcardStore: FlashcardStore
    @State private var currentCardIndex = 0
    @State private var offset: CGSize = .zero
    @State private var isFlipped: Bool = false
    @State var isSavedFlashcardView: Bool = false


    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 50)

            if !flashcards.isEmpty {
                let currentFlashcard = flashcards[currentCardIndex]

                ZStack {
                    // Back of the card
                    Flashcard(front: { Text(currentFlashcard.back) }, back: { Text(currentFlashcard.back) })
                        .opacity(isFlipped ? 1 : 0)
                        .rotation3DEffect(
                            .degrees(isFlipped ? 0 : 180),
                            axis: (x: 0, y: 1, z: 0)
                        )

                    // Front of the card
                    Flashcard(front: { Text(currentFlashcard.front) }, back: { Text(currentFlashcard.back) })
                        .opacity(isFlipped ? 0 : 1)
                        .rotation3DEffect(
                            .degrees(isFlipped ? 180 : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                }
                .onTapGesture {
                    withAnimation {
                        self.isFlipped.toggle()
                    }
                }
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            self.offset = gesture.translation
                        }
                        .onEnded { value in
                            if abs(value.translation.width) > 100 {
                                if value.translation.width < 0 && currentCardIndex < flashcards.count - 1 {
                                    currentCardIndex += 1
                                } else if value.translation.width > 0 && currentCardIndex > 0 {
                                    currentCardIndex -= 1
                                }
                            }
                            offset = .zero
                        }
                )
                .padding(20)
                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                .padding(.horizontal, 10)

                Spacer()

                if !isSavedFlashcardView {
                    Button(action: {
                        let newSet = FlashcardSet(id: UUID().uuidString, title: "Untitled Set", cards: flashcards)
                        flashcardStore.addFlashcardSet(newSet)
                    }) {
                        Text("Save this set")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    }
                    .padding(.bottom, 10)
                }
            } else {
                Text("No flashcards available.")
            }
        }
    }
}
