//
//  LoginView.swift
//  AssignMate
//
//  Created by Jesse Chhina on 10/13/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                //header
                HeaderView(title: "AssignMate",
                           subtitle: "Supercharge your learning.",
                           angle: 15,
                           background: .purple)
                
                //login fields
                Form{
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(Color.red)
                    }
                    
                    
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    AMButton(title: "Log In", 
                             background: .blue)
                    {
                        viewModel.login()
                    }
                    
                }
                VStack{
                    Text("New around here?")
                    
                    NavigationLink("Create An Account",
                                   destination: RegisterView())
                }
                
                //create account
                
                
                Spacer()
            }
        }
        
    }
}

#Preview {
    LoginView()
}
