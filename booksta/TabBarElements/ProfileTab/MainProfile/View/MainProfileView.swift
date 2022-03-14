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
                getProfileView()
                Button(action: viewModel.logOut) {
                    logOutButtonView
                }
                Spacer()
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        .onAppear(perform: viewModel.getUserInformation)
    }
    
    private var logOutButtonView: some View {
        BookstaButton(title: "Log out")
            .clipShape(Capsule())
    }
    
    private func getProfileView() -> some View {
        VStack(spacing: 20) {
            switch viewModel.state {
            case .idle,.loading:
                getProfileHeaderView(mainUser: nil)
                Text("Loading...")
            case let .loaded(user):
                getProfileHeaderView(mainUser: user)
                Text("\(user.email)")
            case let .error(error):
                getProfileHeaderView(mainUser: nil)
                Text("\(error)")
            }
            Spacer()
        }
    }
    
    private func getProfileHeaderView(mainUser: UserModel?) -> some View {
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
                        if let user = mainUser, !user.imageURL.isEmpty{
                            //TODO: add image uploader
//                                Image()
//                                    .resizable()
//                                    .frame(width: 50, height: 50, alignment: .center)
                        } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                        }
                    }
                    Spacer()
                }
                VStack {
                    Text("Following")
                    Text("")
                }
                .padding(.trailing, 20)
            }
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
