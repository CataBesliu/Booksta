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
    @State private var showReadBooks = false
    
    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack(spacing: 20) {
                    profileHeaderView
                    Button(action: {
                        viewModel.isFollowedState ? viewModel.unfollowUser() : viewModel.followUser()
                        viewModel.getIsUserFollowed()
                    }, label: {
                        followButton
                    })
                    Spacer()
                }
                
            }
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
        .onAppear(perform: {
            viewModel.fetchUserData()
        })
        .bookstaNavigationBar(onBackButton: {self.presentationMode.wrappedValue.dismiss()},
                              showBackBtn: true)
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
        .overlay(Circle().stroke(Color.bookstaPurple800, lineWidth: 2))
        
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
                    //                    showReviews.toggle()
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
    
    private var followButton: some View {
        var title: String
        if viewModel.isFollowedState {
            title = "Following"
        } else {
            title = "Follow"
        }
        return BookstaButton(title: title)
        
    }
    
    private var followingView: some View {
        VStack {
            Text("Following")
            switch viewModel.stateForProperties {
            case .idle, .loading:
                Text("...")
            case let .loaded(userProperties):
                Text("\(userProperties.following)")
            case let .error(error):
                EmptyView()
            }
        }
        .padding(.trailing, 20)
    }
}
