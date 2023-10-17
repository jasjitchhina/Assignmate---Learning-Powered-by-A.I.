//
//  NewItemView.swift
//  AssignMate
//
//  Created by Jesse Chhina on 10/13/23.
//


import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var newItemPresented: Bool
    
    
    var body: some View {
        VStack{
            Text("New Assignment")
                .font(.system(size: 32))
                .bold()
                .padding()
            
            Form{
                //course
                TextField("Course Name", text: $viewModel.course)
                    .textFieldStyle(DefaultTextFieldStyle())
                //title
                TextField("Assignment Name", text: $viewModel.title)
                    .textFieldStyle(DefaultTextFieldStyle())
                //due date
                DatePicker("Due Date", selection: $viewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                //button
                AMButton(title: "Save",
                         background: .purple){
                    if viewModel.canSave{
                        viewModel.save()
                        newItemPresented = false
                    } else{
                        viewModel.showAlert = true
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert){
                Alert(title: Text("Error"),
                      message: Text("Fill in all fields and select due date that is not in the past."))
                
            }
        }
    }
}

#Preview {
    NewItemView(newItemPresented: Binding(get: {
        return true
    }, set:{ _ in
    }))
}
