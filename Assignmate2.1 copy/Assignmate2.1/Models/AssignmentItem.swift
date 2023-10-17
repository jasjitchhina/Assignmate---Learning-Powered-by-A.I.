//
//  AssignmentItem.swift
//  Assignmate2.1
//
//  Created by Jesse Chhina on 10/16/23.
//

import Foundation

struct AssignmentItem: Codable, Identifiable{
    let id: String
    let course: String
    let title: String
    let dueDate: TimeInterval
    let createdDate: TimeInterval
    var isDone: Bool
    
    mutating func setDone(_ state: Bool){
        isDone = state
    }
}
