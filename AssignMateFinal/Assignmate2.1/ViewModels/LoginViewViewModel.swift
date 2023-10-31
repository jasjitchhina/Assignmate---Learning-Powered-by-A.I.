//
//  LoginViewViewModel.swift
//  AssignMate
//
//  Created by Jesse Chhina on 10/13/23.
//

import FirebaseAuth
import Foundation

// A view model class for managing the login view
class LoginViewViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init() {}
    
    // Function to perform login
    func login() {
        guard validate() else {
            return
        }
        // Try to log in with the provided email and password
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    // Function to validate user input
    private func validate() -> Bool {
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email."
            return false
        }
        
        return true
    }
}
