//
//  ProfileView.swift
//  booksta
//
//  Created by Catalina Besliu on 20.02.2022.
//

import SwiftUI
import Firebase
import Resolver

struct ProfileView: View {
    @State private var isUserLoggedOut = false
    @ObservedObject var viewModel: ProfileViewModel = Resolver.resolve()
    private var profileImage: UIImage?
    
    init(){
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "photo")
                        .font(.system(size: 30))
                }
                Button(action: viewModel.logOut) {
                    logOutButtonView
                }
                Spacer()
                
            }
            .navigationBarBackButtonHidden(true)
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var logOutButtonView: some View {
        Text("Log out")
            .foregroundColor(.bookstaGrey50)
            .padding(.vertical, 16)
            .padding(.horizontal, 40)
            .background(Color.bookstaPink)
            .clipShape(Capsule())
            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
    }
    
    func handleProfilePhotoSelect() {
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
