//
//  PostViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 17.06.2022.
//

import Foundation
import Firebase

class FeedViewModel: ObservableObject {
    @Published var state = DataState<[UserPostArrayModel]>.idle
    @Published var allPosts = DataState<[UserPostModel]>.idle
    
    
    func fetchPosts() {
        var allPostsArray: [UserPostModel] = []
        var tempPosts: [UserPostModel] = []
        guard state == .idle else {
            return
        }
        state = .loading
        allPosts = .loading
        
        PostService.getFollowingsPosts {[weak self] posts, error in
            guard let `self` = self else { return }
            if let error = error {
                self.state = .error(error)
                self.allPosts = .error(error)
            } else if let posts = posts {
                self.state = .loaded(posts)
                for post in posts {
                    let user = post.user
                    tempPosts = post.post.map({UserPostModel(post: $0, user: user)})
                    for temp in tempPosts {
                        allPostsArray.append(temp)
                    }
                    tempPosts = []
                }
                self.allPosts = .loaded(allPostsArray)
            }
        }
    }
    
    func resetState() {
        state = .idle
        fetchPosts()
    }
}
    
