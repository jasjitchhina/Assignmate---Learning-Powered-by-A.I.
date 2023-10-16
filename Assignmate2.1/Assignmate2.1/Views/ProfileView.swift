//
//  ProfileView.swift
//  AssignMate
//
//  Created by Jesse Chhina on 10/13/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                if let user = viewModel.user{
                    profile(user: user)
                } else{
                    Text("Loading Profile...")
                }
            }
            .navigationTitle("Profile")
        }
        .onAppear{
            viewModel.fetchUser()
        }
    }
    
    
    @ViewBuilder
    func profile(user: User) -> some View {
        Image(systemName: "person.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.purple)
            .frame(width:125, height: 125)
            .padding()
        
        //info: Name, Email, Member since
        VStack(alignment: .leading){
            HStack{
                 Text("Name: ")
                    .bold()
                Text(user.name)
            }
            .padding()
            HStack{
                 Text("Email: ")
                    .bold()
                Text(user.email)
            }
            .padding()
            HStack{
                 Text("Member Since: ")
                    .bold()
                Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
            }
            .padding()
        }
        .padding()
        
        //sign out
        Button ("Log Out") {
            viewModel.logOut()
        }
        .tint(.red)
        .padding()
        
        Spacer()
                 
    }
}

#Preview {
    ProfileView()
}
