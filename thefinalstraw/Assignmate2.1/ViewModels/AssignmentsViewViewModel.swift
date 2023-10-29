//
//  AssignmentsViewViewModel.swift
//  AssignMate
//
//  Created by Jesse Chhina on 10/13/23.
//
import FirebaseFirestore
import Foundation
//VIEW MODEL FOR LIST OF ALL ASSIGNMENTS
//PRIMARY TAB

class AssignmentsViewViewModel: ObservableObject{
    @Published var showingNewItemView = false
    
    private let userId: String
    init(userId: String){
        self.userId =  userId
    }
    
    /// Delete Assignment item
    /// - Parameter id: item id to delete
    func delete(id: String){
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("assignments")
            .document(id)
            .delete()
        
    }
    
}
