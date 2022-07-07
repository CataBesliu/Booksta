//
//  StatisticsViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 04.07.2022.
//

import Foundation
import SwiftUI
import Resolver

class StatisticsViewModel: ObservableObject {
    @Published var stateUserFollowings = DataState<[UserModel]>.idle
    @Published var postsForUsers: [(user: UserModel, posts: [PostModel])] = []
    @Published var booksRead: [(user: UserModel, books: Int)] = []
    var userID = UserDefaults.standard.string(forKey: "userID")
    
    func resetState() {
        stateUserFollowings = .idle
        postsForUsers = []
    }
    
    func fetchData() {
        guard stateUserFollowings == .idle else { return }
        
        stateUserFollowings = .loading
        
        guard let userID = userID else {
            return
        }

        UserService.getUserFollowings(uid: userID) { [weak self] users, error in
            guard let `self` = self else { return }
            if error != nil {
                self.stateUserFollowings = .error("Could not fetch users being followed")
            } else if let users = users {
                self.stateUserFollowings = .loaded(users)
                self.booksRead = users.map({ user in
                    return (user: user, books: user.booksRead.count)
                })
                for user in users {
                    PostService.getUserPosts(uid: user.uid) { posts, error in
                        if error != nil {
                            self.postsForUsers = []
                        } else if var posts = posts {
                            posts.sort(by: { $0.timestamp! > $1.timestamp! })
                            self.postsForUsers.append((user: user, posts: posts))
                        }
                    }
                }
            }
        }
    }
}
