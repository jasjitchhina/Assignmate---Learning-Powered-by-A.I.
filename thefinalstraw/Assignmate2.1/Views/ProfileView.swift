import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    
    var body: some View {
        NavigationView {  // Use NavigationView directly for a better navbar appearance
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
            .navigationTitle("Profile")
            .background(Color(.systemGroupedBackground))
        }
        .onAppear {
            viewModel.fetchUser()
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
                .clipShape(Circle())   // Make the profile picture circular
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
                viewModel.logOut()
            }
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color.red)
            .cornerRadius(8)
            .padding(.bottom, 16)
        }
        .padding(.top, 32)
    }
}
