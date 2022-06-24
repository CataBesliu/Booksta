//
//  EditProfileView.swift
//  booksta
//
//  Created by Catalina Besliu on 20.06.2022.
//

import SwiftUI
import Resolver


struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: MainProfileViewModel = Resolver.resolve()
    @State private var isLibrarySheetPresented = false
    @State private var profileImage: UIImage?
    var oldImageUrl: String = ""
    var genres: [String] = []
    
    init(){
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        VStack {
            profileContent
            Spacer()
        }
        .padding(.horizontal)
        .bookstaNavigationBar(onBackButton: {
            self.presentationMode.wrappedValue.dismiss()},
                              showBackBtn: true,
                              onOkButton: saveFunction)
        .onChange(of: profileImage, perform: { newImage in
            viewModel.resetImageState()
            viewModel.uploadPhoto(image: newImage)
            viewModel.getUserInformation()
        })
        .sheet(isPresented: $isLibrarySheetPresented) {
            ImagePicker(selectedImage: $profileImage)
        }
    }
    
    private var profileContent: some View {
        VStack(spacing: 20) {
            switch viewModel.state {
            case .idle,.loading:
                getProfileHeaderView(mainUser: nil)
                getUserNamesView(mainUser: nil)
                Text("Loading...")
                    .foregroundColor(.bookstaPurple800)
            case let .loaded(user):
                getProfileHeaderView(mainUser: user)
                getUserNamesView(mainUser: user)
                getGenreView(mainUser: user)
            case let .error(error):
                getProfileHeaderView(mainUser: nil)
                getUserNamesView(mainUser: nil)
                Text("\(error)")
                    .foregroundColor(.bookstaPurple800)
            }
        }
    }
    
    private func getGenreView(mainUser: UserModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Preferences")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.bookstaPurple800)
            GenreHeader(genres: mainUser.genres)
                .foregroundColor(.bookstaPurple)
        }
    }
    
    private func getProfileHeaderView(mainUser: UserModel?) -> some View {
        VStack(alignment: .center, spacing: 20) {
            Button(action: {
                isLibrarySheetPresented = true
            }) {
                profileImageView
            }
        }
        .padding(.top)
        .padding(.horizontal, 20)
    }
    
    private var profileImageView: some View {
        return VStack {
            switch viewModel.imageState {
            case .idle,.loading:
                Text("Loading photo...")
                    .foregroundColor(.bookstaPurple800)
                    .frame(width: 70, height: 70, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.bookstaPurple800, lineWidth: 2))
            case let .loaded(imageURL):
                VStack(spacing: 13) {
                    ZStack(alignment: .bottomTrailing) {
                        BookstaImage(url: imageURL,
                                     height: 70,
                                     width: 70,
                                     placeholderImage: "person.crop.circle")
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        
                        Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.black)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .overlay(Circle().stroke(Color.bookstaPurple, lineWidth: 2))
                            .clipped()
                            .padding(.trailing, 10)
                            .zIndex(1)
                    }
                    Text("Edit photo")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.bookstaPurple)
                
            case let .error(_):
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 70, height: 70, alignment: .center)
                    .foregroundColor(.bookstaPurple800)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.bookstaPurple800, lineWidth: 2))
            }
        }
    }
    
    private func getUserNamesView(mainUser: UserModel?) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Reader handle")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.bookstaPurple800)
                VStack(alignment: .leading, spacing: 2) {
                    Text("@\(mainUser?.username ?? "-")")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    Divider()
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("My email")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.bookstaPurple800)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(mainUser?.email ?? "-")")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    Divider()
                }
            }
        }
    }
    
    
    private func saveFunction() {
        print("ok")
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
