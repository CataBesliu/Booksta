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
            .bookstaNavigationBar(onBackButton: {self.presentationMode.wrappedValue.dismiss()},
                                  showBackBtn: true, onOkButton: nil)
        }
    }
    
    private var profileHeaderView: some View {
        VStack(spacing: 30) {
            HStack(spacing: 13){
                profileImageView
                Text("@\(viewModel.user.username)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.bookstaPurple800)
                    .padding(.bottom, 10)
                Spacer()
                followButton
            }
            profileProperties
            
        }
        .padding(.vertical)
        .padding(.horizontal, 20)
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
                        .foregroundColor(.bookstaPurple800)
                    Text("following")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.bookstaPurple800)
                }
            }
            
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
                        .foregroundColor(.bookstaPurple800)
                    Text("books read")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.bookstaPurple800)
                }
            }
            
            Divider().frame(width: 2, height: 20)
                .foregroundColor(.bookstaPurple)
            
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
        ScrollView {
            VStack(spacing: 15) {
                Text("\(viewModel.user.username)`s posts")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.bookstaPurple800)
                    .padding(.leading)
                    .padding(.top, 7)
                    .leadingStyle()
                    .background(.white)
                switch viewModel.postsState {
                case .idle, .loading:
                    Text("Loading...")
                        .foregroundColor(.bookstaPurple800)
                        .centerStyle()
                case let .loaded(posts):
                    if let user = viewModel.user {
                        VStack(spacing: 0) {
                            ForEach(posts, id: \.self) { post in
                                PostView(userPostModel: UserPostModel(post: post, user: user))
                                    .background(.white)
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
    
}
