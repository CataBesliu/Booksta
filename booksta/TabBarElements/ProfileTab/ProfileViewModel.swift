//
//  ProfileViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 21.06.2022.
//

import Foundation
import Firebase
import Resolver

class ProfileViewModel: ObservableObject {
    @Published var state = DataState<UserModel>.idle
    @Published var postsState = DataState<[PostModel]>.idle
    
    @Published var books: [BookModel]?
    @Published var reviews: [ReviewModel]?
    @Published var followings: [UserModel]?
    @Published var showReadBooks = false
    @Published var showFollowings = false
    
    
    func getProfileInformation(user: UserModel) {
        getUserBooks(user: user)
        getUserReviews(user: user)
        getUserFollowings(user: user)
        
        postsState = .idle
        getUserPosts(user: user)
    }
    
    func getUserBooks(user: UserModel) {
        UserService.getBooksRead(user) { [weak self] books,error in
            guard let `self` = self else { return }
            if let error = error {
                print(error)
            } else if let books = books {
                self.books = books
            }
        }
    }
    
    func getUserReviews(user: UserModel) {
        ReviewService.getReviewsForUser(userID: user.uid) { [weak self] reviews,error in
            guard let `self` = self else { return }
            if let error = error {
                print(error)
            } else if let reviews = reviews {
                self.reviews = reviews
            }
        }
    }
    
    func getUserFollowings(user: UserModel) {
        UserService.getUserFollowings(uid: user.uid) { [weak self] followings,error in
            guard let `self` = self else { return }
            if let error = error {
                print(error)
            } else if let followings = followings {
                self.followings = followings
            }
        }
    }
    
    func getUserPosts(user: UserModel) {
        guard postsState == .idle else {
            return
        }
        postsState = .loading
        
        PostService.getUserPosts(uid: user.uid) { [weak self] posts,error in
            guard let `self` = self else { return }
            if let error = error {
                self.postsState = .error(error)
            } else if let posts = posts {
                self.postsState = .loaded(posts)
            }
        }
    }
}
