import SwiftUI
import FirebaseAuth

struct SavedFlashcardsView: View {
    @EnvironmentObject var flashcardStore: FlashcardStore
    @State private var isEditing = false
    @State private var currentEditingSet: FlashcardSet?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(flashcardStore.flashcardSets, id: \.id) { flashcardSet in
                    HStack {
                        if isEditing && currentEditingSet?.id == flashcardSet.id {
                            // Text field for editing the flashcard set name
                            TextField("Edit Name", text: Binding<String>(
                                get: { currentEditingSet?.title ?? "" },
                                set: { newValue in
                                    self.currentEditingSet?.title = newValue
                                }
                            ))
                            // Save button to update the flashcard set name
                            Button("Save") {
                                if let updatedSet = currentEditingSet {
                                    flashcardStore.updateFlashcardSetTitle(id: updatedSet.id, newTitle: updatedSet.title, for: Auth.auth().currentUser?.uid ?? "")
                                }
                                isEditing = false
                                currentEditingSet = nil
                            }
                        } else {
                            // Navigation link to view the flashcards in the set
                            NavigationLink(destination: FlashcardStack(flashcards: flashcardSet.cards, isSavedFlashcardView: true)) {
                                Text(flashcardSet.title)
                            }
                            Spacer()
                            // Edit button to edit the flashcard set name
                            Button("Edit") {
                                currentEditingSet = flashcardSet
                                isEditing = true
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                }
                .onDelete(perform: deleteFlashcardSet)
            }
            .navigationBarTitle("Saved Flashcards")
            .onAppear {
                self.flashcardStore.fetchFlashcardSets() // Fetch saved flashcard sets
            }
        }
    }
    
    // Function to delete a flashcard set at specified offsets
    func deleteFlashcardSet(at offsets: IndexSet) {
        if let userId = Auth.auth().currentUser?.uid {
            let setsToDelete = offsets.map { flashcardStore.flashcardSets[$0] }
            for set in setsToDelete {
                flashcardStore.deleteFlashcardSet(set: set, for: userId) // Delete the selected flashcard sets
            }
        }
    }
}
