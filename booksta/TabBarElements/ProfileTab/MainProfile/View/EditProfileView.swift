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
    @EnvironmentObject var mainCheck: LogoutMainCheck
    @ObservedObject var mainViewModel: MainProfileViewModel = Resolver.resolve()
    @ObservedObject var viewModel: EditProfileViewModel = EditProfileViewModel()
    
    @State private var isLibrarySheetPresented = false
    @State private var profileImage: UIImage?
    
    init() {
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        VStack {
            profileContent
            Spacer()
            logOutButton
            Spacer()
        }
        .padding()
        .bookstaNavigationBar(title: "Edit profile",
                              showBackBtn: true,
                              onBackButton: { viewModel.canGoBackFunction() },
                              onOkButton: saveFunction)
        .onChange(of: profileImage, perform: { newImage in
            viewModel.resetImageState()
            viewModel.uploadPhoto(image: newImage)
            viewModel.getUserInformation()
        })
        .onChange(of: viewModel.canGoForth, perform: { newValue in
            if newValue {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
        .onChange(of: viewModel.canGoBack, perform: { newValue in
            if newValue {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
        .sheet(isPresented: $isLibrarySheetPresented) {
            ImagePicker(selectedImage: $profileImage)
        }
        .onAppear {
            viewModel.getUserInformation()
            viewModel.getAllGenres()
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
                if viewModel.areGenresSet {
                    getGenreView()
                }
            case let .error(error):
                getProfileHeaderView(mainUser: nil)
                getUserNamesView(mainUser: nil)
                Text("\(error)")
                    .foregroundColor(.bookstaPurple800)
            }
        }
    }
    
    private var logOutButton: some View {
        Button(action: { mainViewModel.logOut(logout: $mainCheck.logout) }) {
            BookstaButton(title: "Log out")
                .clipShape(Capsule())
        }
    }
    
    private func getGenreView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Preferences")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.bookstaPurple800)
                .leadingStyle()
            if viewModel.newGenres.count == 0 {
                Text("Personalize with your unique taste in genres ")
                    .font(.system(size: 18))
                    .foregroundColor(.bookstaPurple800)
                    .leadingStyle()
            }
            GenreHeader(viewModel: viewModel)
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
                    BookstaImage(url: imageURL,
                                 height: 70,
                                 width: 70,
                                 placeholderImage: "person.crop.circle")
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .overlay(Circle().stroke(Color.bookstaPurple, lineWidth: 2))
                    
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
        viewModel.saveChanges()
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
