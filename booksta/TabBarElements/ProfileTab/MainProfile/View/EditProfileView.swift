//
//  EditProfileView.swift
//  booksta
//
//  Created by Catalina Besliu on 20.06.2022.
//

import SwiftUI


struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            title
            Divider()
                .frame(height: 1)
                .foregroundColor(.bookstaPurple800)
            profileContent
            Spacer()
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.backward.square")
                    .resizable()
                    .frame(width: 15, height: 15)
                Text("Go back")
            }
            .foregroundColor(.bookstaPurple)
            .leadingStyle()
        }
    }
    
    private var profileContent: some View {
        Text("bla")
    }
    
    private var title: some View  {
        Text("Edit profile")
            .font(.system(size: 20, weight: .bold))
            .padding(.horizontal)
            .padding(.bottom, 10)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
