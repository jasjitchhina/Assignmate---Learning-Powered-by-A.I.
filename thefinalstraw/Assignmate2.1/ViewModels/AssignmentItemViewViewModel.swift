//
//  AssignmentItemViewViewModel.swift
//  AssignMate
//
//  Created by Jesse Chhina on 10/13/23.
//
//


//SINGLE ITEM VIEW
//SINGLE
import FirebaseAuth
import FirebaseFirestore
import Foundation
class AssignmentItemViewViewModel: ObservableObject{
    init(){}
    
    func toggleIsDone(item: AssignmentItem){
        var itemCopy = item
        itemCopy.setDone(!item.isDone)
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("assignments")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
    }
    
}
