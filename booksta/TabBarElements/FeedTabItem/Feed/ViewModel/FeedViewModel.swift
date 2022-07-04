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
    var followersListeners: ListenerRegistration?
    var followers: [UserModel] = [] {
        didSet {
//            resetListeners()
        }
    }
    var listeners: [ListenerRegistration] = []
    
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
                allPostsArray.sort(by: { $0.post.timestamp! > $1.post.timestamp! })
                self.allPosts = .loaded(allPostsArray)
            }
        }
    }
    
    func resetState() {
        state = .idle
        fetchPosts()
    }
}
    
//    func getFollowings(completion: @escaping([UserPostArrayModel]?,String?) -> Void) {
//        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
//        var userPosts: [UserPostArrayModel] = []
//
//        //        self.listener?.remove()
//
//        PostService.getFollowingUsers { [weak self] users, error in
//            guard let `self` = self else { return }
//            if let error = error {
//                print("DEBUG: Error retrieving reviews - \(error)")
//                self.followers = []
//                return
//            }
//            guard let users = users else {
//                return
//            }
//
//            self.followers = users
//        }
//    }
//
//    func resetListeners(users: [UserModel]) {
//        for user in users {
//            var tempListener = POSTS_COLLECTION.document(user.uid).collection(USER_POSTS_COLLECTION).addSnapshotListener { documentSnapshot, error in
//                if let error = error {
//                    print("DEBUG: Error retrieving posts - \(error.localizedDescription)")
//                    return
//                }
//
//                guard let data = documentSnapshot else { return }
//                let posts = data.documents.map ({ PostModel(dictionary: $0.data(), uid: uid, bookID: $0.documentID) })
//                completion(posts, nil)
//            }
//        }
//}
