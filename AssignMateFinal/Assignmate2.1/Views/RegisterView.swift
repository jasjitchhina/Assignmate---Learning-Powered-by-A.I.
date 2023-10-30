//
//  RegisterView.swift
//  AssignMate
//
//  Created by Jesse Chhina on 10/13/23.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    
    var body: some View {
        VStack{
            //header
           HeaderView(title: "Register",
                    subtitle: "Start supercharging your learning.",
                            angle: -15,
                        background: .blue)
            
            Form{
                TextField("Full Name", text: $viewModel.name)
                    . textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()

                TextField("Email Address", text: $viewModel.email)
                    . textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                
                
                SecureField("Password", text: $viewModel.password)
                    . textFieldStyle(DefaultTextFieldStyle())
             
                AMButton(title: "Create Account",
                         background: .green)
                {
                    viewModel.register()
                }
                
            }
            .offset(y: -50)
            
            Spacer()
            
        }
    }
}

#Preview {
    RegisterView()
}
