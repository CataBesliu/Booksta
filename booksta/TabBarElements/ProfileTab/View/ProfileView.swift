//
//  ProfileView.swift
//  booksta
//
//  Created by Catalina Besliu on 20.02.2022.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    private var profileImage: UIImage?
    
    var body: some View {
        VStack {
        Button(action: {
            
        }) {
            Image(systemName: "photo")
                .font(.system(size: 30))
        }
            Button(action: logOut) {
                logOutButtonView
            }

        }
        .navigationBarBackButtonHidden(true)
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
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    func handleProfilePhotoSelect() {
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
