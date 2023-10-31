import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if let user = viewModel.user {
                    profile(user: user)
                } else {
                    Text("Loading Profile...")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .navigationTitle("Profile") // Set the navigation title
            .background(Color(.systemGroupedBackground)) // Set the background color
        }
        .onAppear {
            viewModel.fetchUser() // Fetch the user data when the view appears
        }
    }
    
    @ViewBuilder
    func profile(user: User) -> some View {
        VStack(spacing: 32) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.purple)
                .frame(width: 125, height: 125)
                .clipShape(Circle()) // Make the profile picture circular
                .padding()
            
            VStack(alignment: .leading, spacing: 16) {
                Label("Name: \(user.name)", systemImage: "person.fill")
                Label("Email: \(user.email)", systemImage: "envelope.fill")
                Label("Member Since: \(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))", systemImage: "calendar")
            }
            .font(.body)
            .padding(.horizontal)
            
            Spacer()
            
            Button("Log Out") {
                viewModel.logOut() // Log out when the button is tapped
            }
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color.red)
            .cornerRadius(8)
            .padding(.bottom, 16)
        }
        .padding(.top, 32)
        .padding(.bottom, 20)
    }
}
