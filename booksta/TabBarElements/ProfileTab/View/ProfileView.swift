//
//  ProfileView.swift
//  booksta
//
//  Created by Catalina Besliu on 20.02.2022.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        Button(action: {
            
        }) {
            Image(systemName: "photo")
                .font(.system(size: 30))
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func handleProfilePhotoSelect() {
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
