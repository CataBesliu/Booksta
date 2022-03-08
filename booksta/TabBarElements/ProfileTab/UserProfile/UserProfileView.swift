//
//  UserProfileView.swift
//  booksta
//
//  Created by Catalina Besliu on 08.03.2022.
//

import SwiftUI

struct UserProfileView: View {
    var user: UserModel
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .leading) {
                VStack {
                    Text("Books read")
                    Text("")
                }
                .padding(.leading, 20)
                ZStack(alignment: .trailing){
                    HStack{
                        Spacer()
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                        Spacer()
                    }
                    VStack {
                        Text("Following")
                        Text("")
                    }
                    .padding(.trailing, 20)
                }
            }
            Text("\(user.email)")
            Spacer()
        }
    }
    func handleProfilePhotoSelect() {
        print("print")
    }
}

//struct UserProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfileView(user: UserModel(dictionary:))
//    }
//}
