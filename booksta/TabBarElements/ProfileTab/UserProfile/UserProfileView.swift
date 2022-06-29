//
//  UserProfileView.swift
//  booksta
//
//  Created by Catalina Besliu on 08.03.2022.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: UserProfileViewModel
    
    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack(spacing: 12) {
                    profileHeaderView
                    Divider()
                    postsView
                    Spacer()
                }
                
                if viewModel.showReadBooks {
                    BooksScrollView(books: viewModel.books)
                        .modalPresenter(title: "Books read", onDismiss: {
                            withAnimation(.easeIn(duration: 0.5)) {
                                viewModel.showReadBooks = false
                            }
                        })
                        .transition(.bottomslide)
                        .frame(height: geometry.size.height - 150)
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
            .onAppear(perform: {
                viewModel.fetchUserData()
            })
            .bookstaNavigationBar(showBackBtn: true,
                                  onBackButton: {self.presentationMode.wrappedValue.dismiss()})
        }
    }
    
    private var profileHeaderView: some View {
        VStack(spacing: 15) {
            HStack(spacing: 13){
                profileImageView
                Text("@\(viewModel.user.username)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.bookstaPurple800)
                    .padding(.bottom, 10)
                Spacer()
                followButton
            }
            VStack(spacing: 20) {
                profileProperties
                ProfileGenreHeader(genres: viewModel.user.genres)
            }
            
        }
        .padding(.top)
        .padding(.horizontal)
    }
    
    private var profileImageView: some View {
        BookstaImage(url: viewModel.user.imageURL,
                     height: 60,
                     width: 60,
                     placeholderImage: "person.crop.circle")
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 2))
        
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
    
    private var followButton: some View {
        var title: String { viewModel.isFollowedState ? "Following" : "Follow" }
        return Button(action: {
            viewModel.isFollowedState ? viewModel.unfollowUser() : viewModel.followUser()
            viewModel.getIsUserFollowed()
        }, label: {
            BookstaButton(title: title, paddingV: 5, paddingH: 10, titleSize: 17, titleWeight: .semibold)
        })
    }
    
    private var postsView: some View {
        VStack {
            VStack {
                Text("Posts")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.bookstaPurple800)
                    .padding(.leading)
                    .padding(.top, 7)
                    .leadingStyle()
                    .background(.white)
//                CustomDivider(color: Color.bookstaGrey200.opacity(0.5), width: 1)
            }
            ScrollView {
                switch viewModel.postsState {
                case .idle, .loading:
                    Text("Loading...")
                        .foregroundColor(.bookstaPurple800)
                        .centerStyle()
                case let .loaded(posts):
                    if let user = viewModel.user {
                        if posts.count == 0 {
                            Text("No posts added")
                                .font(.system(size: 16))
                                .foregroundColor(.bookstaPurple800)
                        } else {
                            VStack {
                                ForEach(posts, id: \.self) { post in
                                    PostView(userPostModel: UserPostModel(post: post, user: user))
                                        .background(.white)
                                }
                            }
                        }
                    }
                case let .error(error):
                    Text("\(error)")
                        .foregroundColor(.bookstaPurple800)
                        .centerStyle()
                }
            }
        }
    }
}
