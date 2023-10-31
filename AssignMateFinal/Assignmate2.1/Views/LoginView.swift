import SwiftUI

// A view for user login
struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                // Header view with the app title, subtitle, angle, and background color
                HeaderView(title: "AssignMate",
                           subtitle: "Supercharge your learning.",
                           angle: 15,
                           background: .purple)
                
                // Login form
                Form{
                    // Display error message if it's not empty
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(Color.red)
                    }
                    
                    // Email address text field
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    
                    // Password secure text field
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    // Login button
                    AMButton(title: "Log In", background: .blue) {
                        viewModel.login()
                    }
                }
                
                // Create account section
                VStack{
                    Text("New around here?")
                    
                    // Navigation link to the registration view
                    NavigationLink("Create An Account", destination: RegisterView())
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    // Example usage of the LoginView
    LoginView()
}
