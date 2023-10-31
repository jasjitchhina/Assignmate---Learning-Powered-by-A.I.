import FirebaseFirestoreSwift
import SwiftUI

// A view for displaying a list of assignments
struct AssignmentsView: View {
    @StateObject var viewModel : AssignmentsViewViewModel
    @FirestoreQuery var items: [AssignmentItem]
    
    // Sorted items based on urgency
    var sortedItems: [AssignmentItem] {
        items.sorted(by: {
            switch ($0.urgency, $1.urgency) {
            case ("High", "Normal"), ("High", "Low"), ("Normal", "Low"):
                return true
            default:
                return false
            }
        })
    }

    // Initialize the view with a user's ID
    init(userId: String){
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/assignments")
        self._viewModel = StateObject(wrappedValue: AssignmentsViewViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                List(sortedItems) { item in  // Use the sortedItems here
                    AssignmentItemView(item: item)
                        .swipeActions{
                            Button("Delete"){
                                viewModel.delete(id: item.id)
                            }
                            .tint(.red)
                        }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Assignments")
            .toolbar{
                Button{
                    viewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView(newItemPresented: $viewModel.showingNewItemView)
            }
        }
    }
}
