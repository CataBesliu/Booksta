//
//  ProfileView.swift
//  booksta
//
//  Created by Catalina Besliu on 20.02.2022.
//

import SwiftUI
import Firebase
import Resolver
import SDWebImageSwiftUI

struct MainProfileView: View {
    @State private var isUserLoggedOut = false
    @ObservedObject var viewModel: ProfileViewModel = Resolver.resolve()
    @State private var profileImage: UIImage?
    @State private var isLibrarySheetPresented = false
    
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
            .background(Color.white)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        .onAppear(perform: {
            viewModel.getUserInformation()
        })
        .onChange(of: profileImage, perform: { newImage in
            viewModel.resetImageState()
            viewModel.uploadPhoto(image: newImage)
            viewModel.getUserInformation()
        })
        .sheet(isPresented: $isLibrarySheetPresented) {
            ImagePicker(selectedImage: $profileImage)
        }
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
                    .foregroundColor(.bookstaPurple800)
            case let .loaded(user):
                getProfileHeaderView(mainUser: user)
                Text("\(user.email)")
                    .foregroundColor(.bookstaPurple800)
            case let .error(error):
                getProfileHeaderView(mainUser: nil)
                Text("\(error)")
                    .foregroundColor(.bookstaPurple800)
            }
            Spacer()
        }
    }
    
    private func getProfileHeaderView(mainUser: UserModel?) -> some View {
        ZStack(alignment: .leading) {
            VStack {
                Text("Books read")
                    .foregroundColor(.bookstaPurple800)
                Text("")
            }
            .padding(.leading, 20)
            ZStack(alignment: .trailing){
                HStack{
                    Spacer()
                    Button(action: {
                        //TODO: Add photo functionality
                        isLibrarySheetPresented = true
                    }) {
                        getProfileImageView(mainUser: mainUser)
                    }
                    Spacer()
                }
                VStack {
                    Text("Following")
                        .foregroundColor(.bookstaPurple800)
                    Text("")
                }
                .padding(.trailing, 20)
            }
        }
    }
    
    func getProfileImageView(mainUser: UserModel?) -> some View {
        return VStack {
            switch viewModel.imageState {
            case .idle,.loading:
                Text("Loading...")
                    .foregroundColor(.bookstaPurple800)
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.bookstaPurple800, lineWidth: 2))
            case let .loaded(imageURL):
                if !imageURL.isEmpty {
                WebImage(url: URL(string: imageURL))
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.bookstaPurple800, lineWidth: 2))
                    .eraseToAnyView()
                } else {
                    getImageResized(image: Image(systemName: "person.crop.circle"))
                        .eraseToAnyView()
                }
            case let .error(_):
                //TODO: implement error
                getImageResized(image: Image(systemName: "person.crop.circle"))
                    .eraseToAnyView()
            }
        }
    }
    
    func getImageResized(image: Image) -> some View {
        return image
            .resizable()
            .frame(width: 100, height: 100, alignment: .center)
            .foregroundColor(.bookstaPurple800)
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.bookstaPurple800, lineWidth: 2))
    }
    
    func handleProfilePhotoSelect() {
        isLibrarySheetPresented = true
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MainProfileView()
    }
}
