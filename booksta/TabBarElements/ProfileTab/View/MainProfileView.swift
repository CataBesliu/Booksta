//
//  ProfileView.swift
//  booksta
//
//  Created by Catalina Besliu on 20.02.2022.
//

import SwiftUI
import Firebase
import Resolver

struct MainProfileView: View {
    @State private var isUserLoggedOut = false
    @ObservedObject var viewModel: ProfileViewModel = Resolver.resolve()
    private var profileImage: UIImage?
    
    init(){
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let user = viewModel.user {
                    ProfileView(user: user, isMainProfile: true)
                }
                Button(action: viewModel.logOut) {
                    logOutButtonView
                }
                Spacer()
                
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear(perform: viewModel.getUserInformation)
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
}

struct ProfileView: View {
    var user: UserModel
    var isMainProfile: Bool = false
    
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
                        Button(action: {
                            //TODO: Add photo functionality
                            handleProfilePhotoSelect()
                        }) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                        }
                        .disabled(!isMainProfile)
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
        }
    }
    func handleProfilePhotoSelect() {
        print("print")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MainProfileView()
    }
}
