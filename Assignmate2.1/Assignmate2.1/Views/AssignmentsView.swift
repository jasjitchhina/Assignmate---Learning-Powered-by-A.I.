//
//  AssignmentItemView.swift
//  AssignMate
//
//  Created by Jesse Chhina on 10/13/23.
//

import FirebaseFirestoreSwift
import SwiftUI

struct AssignmentsView: View {
    @StateObject var viewModel : AssignmentsViewViewModel
    @FirestoreQuery var items: [AssignmentItem]
    
    
    init(userId: String){
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/assignments")
        self._viewModel = StateObject(wrappedValue: AssignmentsViewViewModel (userId: userId))
    }
    
    
    var body: some View {
        NavigationStack{
            VStack{
                List(items) {item in
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

#Preview {
    AssignmentsView(userId: "avlMHhXNZFNOUzW7S6Rw2Ua1wNP2")
}
