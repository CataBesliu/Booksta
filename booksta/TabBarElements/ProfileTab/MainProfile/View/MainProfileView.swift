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
    @ObservedObject var viewModel: MainProfileViewModel = Resolver.resolve()
    @State private var profileImage: UIImage?
    @State private var isLibrarySheetPresented = false
    @State private var showReadBooks = false
    @State private var showReviews = false
    
    init(){
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                        profileContent

                    if showReadBooks {
                        BooksScrollView(books: viewModel.books)
                            .modalPresenter(title: "Books read", onDismiss: {
                                withAnimation(.easeIn(duration: 0.5)) {
                                    showReadBooks = false
                                }
                            })
                            .transition(.bottomslide)
                            .frame(height: geometry.size.height - 200)
                            .zIndex(1)
                    }
                }
                .bookstaNavigationBar(onBackButton: {}, showBackBtn: false)
                .onAppear(perform: {
                    viewModel.getUserBooks()
                    viewModel.getUserReviews()
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
        }
    }
    
    private var bookstaLogo: some View  {
        HStack {
            Image("iconLogo")
                .resizable()
                .frame(width: 100, height: 20)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
    
    private var profileContent: some View {
        VStack(spacing: 20) {
            getProfileView()
            Button(action: viewModel.logOut) {
                logOutButtonView
            }
            Spacer()
            
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
            case let .error(error):
                getProfileHeaderView(mainUser: nil)
                Text("\(error)")
                    .foregroundColor(.bookstaPurple800)
            }
        }
    }
    
    private func getProfileHeaderView(mainUser: UserModel?) -> some View {
        VStack(spacing: 30) {
            HStack(spacing: 13){
                Button(action: {
                    //TODO: Add photo functionality
                    isLibrarySheetPresented = true
                }) {
                    getProfileImageView()
                }
                Text("@\(viewModel.user?.username ?? "-")")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.bookstaPurple800)
                    .padding(.bottom, 10)
                Spacer()
                NavigationLink {
                    withAnimation(.spring(response: 1, dampingFraction: 1, blendDuration: 0.2)) { EditProfileView()}
                } label: {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(.bookstaPurple800)
                }
            }
            profileProperties
            Spacer()
            
        }
        .padding(.vertical)
        .padding(.horizontal, 20)
    }
    
    
    private var profileProperties: some View {
        HStack(spacing: 20) {
            VStack(spacing: 5) {
                Text("234")
                    .font(.system(size: 19, weight: .bold))
                    .foregroundColor(.bookstaPurple800)
                Text("following")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.bookstaPurple800)
            }
            
            Divider().frame(width: 2, height: 20)
                .foregroundColor(.bookstaPurple)
            
            Button {
                withAnimation(.easeIn(duration: 0.5)) {
                    showReadBooks.toggle()
                }
            } label: {
                VStack(spacing: 5) {
                    Text("\(viewModel.books?.count ?? 0)")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(.bookstaPurple800)
                    Text("books read")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.bookstaPurple800)
                }
            }
            
            Divider().frame(width: 2, height: 20)
                .foregroundColor(.bookstaPurple)
            
            Button {
                withAnimation(.easeIn(duration: 0.5)) {
                    showReviews.toggle()
                }
            } label: {
                VStack(spacing: 5) {
                    Text("\(viewModel.reviews?.count ?? 0)")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(.bookstaPurple800)
                    Text("reviews")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.bookstaPurple800)
                }
            }
        }
    }
    
    func getProfileImageView() -> some View {
        return VStack {
            switch viewModel.imageState {
            case .idle,.loading:
                Text("Loading...")
                    .foregroundColor(.bookstaPurple800)
                    .frame(width: 60, height: 60, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.bookstaPurple800, lineWidth: 2))
            case let .loaded(imageURL):
                BookstaImage(url: imageURL,
                             height: 60,
                             width: 60,
                             placeholderImage: "person.crop.circle")
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.bookstaPurple800, lineWidth: 2))
                .eraseToAnyView()
                
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
            .frame(width: 60, height: 60, alignment: .center)
            .foregroundColor(.bookstaPurple800)
            .clipShape(Circle())
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
