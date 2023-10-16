//
//  AssignmentItemView.swift
//  AssignMate
//
//  Created by Jesse Chhina on 10/13/23.
//

import SwiftUI

struct AssignmentItemView: View {
    @StateObject var viewModel = AssignmentItemViewViewModel()
    
    let item: AssignmentItem
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(item.title)
                    .font(.body)
                    .bold()
                Text(item.course)
                    .font(.body)
                    .bold()
                Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            Spacer()
            
            Button{
                viewModel.toggleIsDone(item: item)
            }label: {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(Color.purple)
            }
            
        }
    }
}

#Preview {
    AssignmentItemView(item: .init(
        id: "123",
        course: "AP gov",
        title: "Chapter Notes",
        dueDate: Date().timeIntervalSince1970,
        createdDate: Date().timeIntervalSince1970,
        isDone: false
    ))
}
