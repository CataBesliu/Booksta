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
    //    @State private var profileImage: UIImage?
    //    @State private var isLibrarySheetPresented = false
    
    init(){
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    profileContent
                    
                    if viewModel.showReadBooks {
                        BooksScrollView(books: viewModel.books)
                            .modalPresenter(title: "Books read", onDismiss: {
                                withAnimation(.easeIn(duration: 0.5)) {
                                    viewModel.showReadBooks = false
                                }
                            })
                            .transition(.bottomslide)
                            .frame(height: geometry.size.height - 200)
                            .zIndex(1)
                    }
                    
                    if viewModel.showFollowings {
                        UsersScrollView(users: viewModel.followings)
                            .modalPresenter(title: "Following", onDismiss: {
                                withAnimation(.easeIn(duration: 0.5)) {
                                    viewModel.showFollowings = false
                                }
                            })
                            .transition(.bottomslide)
                            .frame(height: geometry.size.height - 150)
                            .zIndex(1)
                    }
                }
                .bookstaNavigationBar(onBackButton: {}, showBackBtn: false, onOkButton: nil)
                .onAppear(perform: {
                    viewModel.getProfileInformation()
                })
                //                .onChange(of: profileImage, perform: { newImage in
                //                    viewModel.resetImageState()
                //                    viewModel.uploadPhoto(image: newImage)
                //                    viewModel.getUserInformation()
                //                })
                //                .sheet(isPresented: $isLibrarySheetPresented) {
                //                    ImagePicker(selectedImage: $profileImage)
                //                }
            }
        }
    }
    
    private var profileContent: some View {
        VStack {
            VStack(spacing: 12) {
                profileView
                Divider()
                postsView
            }
            Spacer()
            
        }
    }
    
    private var profileView: some View {
        VStack(spacing: 10) {
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
    
    private var profileProperties: some View {
        HStack(spacing: 20) {
            Button {
                withAnimation(.easeIn(duration: 0.5)) {
                    viewModel.showFollowings.toggle()
                }
            } label: {
                VStack(spacing: 5) {
                    Text("\(viewModel.followings?.count ?? 0)")
                        .font(.system(size: 19, weight: .bold))
                    Text("following")
                        .font(.system(size: 12, weight: .semibold))
                }
            }
            .foregroundColor(.bookstaPurple)
            
            Divider().frame(width: 2, height: 20)
                .foregroundColor(.bookstaPurple)
            
            Button {
                withAnimation(.easeIn(duration: 0.5)) {
                    viewModel.showReadBooks.toggle()
                }
            } label: {
                VStack(spacing: 5) {
                    Text("\(viewModel.books?.count ?? 0)")
                        .font(.system(size: 19, weight: .bold))
                    Text("books read")
                        .font(.system(size: 12, weight: .semibold))
                }
            }
            .foregroundColor(.bookstaPurple)
            
            Divider().frame(width: 2, height: 20)
                .foregroundColor(.bookstaPurple)
            
            VStack(spacing: 5) {
                Text("\(viewModel.reviews?.count ?? 0)")
                    .font(.system(size: 19, weight: .bold))
                Text("reviews")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(.bookstaPurple)
        }
        
    }
    
    private var postsView: some View {
        VStack {
            Text("My posts")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.bookstaPurple800)
                .padding(.leading)
                .padding(.top, 7)
                .leadingStyle()
                .background(.clear)
            CustomDivider(color: Color.bookstaGrey200.opacity(0.5), width: 5)
            ScrollView {
                switch viewModel.postsState {
                case .idle, .loading:
                    Text("Loading...")
                        .foregroundColor(.bookstaPurple800)
                        .centerStyle()
                case let .loaded(posts):
                    if let user = viewModel.user {
                        VStack {
                            if posts.count == 0 {
                                NavigationLink(destination: AddPostView()) {
                                    Text("Add your first post")
                                        .font(.system(size: 16))
                                        .foregroundColor(.bookstaPurple)
                                }
                            } else {
                                ForEach(posts, id: \.self) { post in
                                    PostView(userPostModel: UserPostModel(post: post, user: user), isActiveLink: false)
                                        .background(.white)
                                }
                            }
                        }
                        .background(Color.bookstaGrey200.opacity(0.5))
                    }
                case let .error(error):
                    Text("\(error)")
                        .foregroundColor(.bookstaPurple800)
                        .centerStyle()
                }
                
                
            }
        }
    }
    
    private func getProfileHeaderView(mainUser: UserModel?) -> some View {
        VStack(spacing: 20) {
            HStack(spacing: 13){
                Button(action: {
                    //                    isLibrarySheetPresented = true
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
            
        }
        .padding(.top)
        .padding(.horizontal, 20)
    }
    
    private func getProfileImageView() -> some View {
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
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .eraseToAnyView()
                
            case let .error(_):
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 60, height: 60, alignment: .center)
                    .foregroundColor(.bookstaPurple800)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.bookstaPurple800, lineWidth: 2))
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MainProfileView()
    }
}
