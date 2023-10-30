//
//  NewItemViewViewModel.swift
//  AssignMate
//
//  Created by Jesse Chhina on 10/13/23.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class NewItemViewViewModel: ObservableObject{
    @Published var title = ""
    @Published var dueDate = Date()
    @Published var course = ""
    @Published var showAlert = false
    @Published var urgency = "Normal" // or whatever default value you want
    @Published var points: Int = 0
    
    init(){}
    
    func save(){
        guard canSave else {
            return
        }
        //Get current user id
        guard let uId = Auth.auth().currentUser?.uid else{
            return
        }
        
        //create model
        let newId = UUID().uuidString
        let newItem = AssignmentItem(
            id: newId,
            course: course,
            title: title,
            dueDate: dueDate.timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false,
            urgency: urgency, // new
            points: points // new
        )
        
        //save model
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("assignments")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard !course.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }
        return true
    }
}
