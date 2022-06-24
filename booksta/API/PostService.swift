//
//  PostService.swift
//  booksta
//
//  Created by Catalina Besliu on 17.06.2022.
//

import Foundation
import Firebase

struct PostService {
    
    static func sendPost(bookID: String, bookName: String, postDescription: String = "", postPhoto: String = "", completion: @escaping(FirestoreTypeCompletion)) {
        let stringArray: [String] = []
        let intArray: [Int] = []
        let docData: [String: Any] = ["bookName": bookName,
                                      "description": postDescription,
                                      "imageURL": postPhoto,
                                      "likes": stringArray,
                                      "comments": stringArray,
                                      "timestamp": ReviewService.getDate()]
        
        
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        POSTS_COLLECTION.document(currentUserUID).collection(USER_POSTS_COLLECTION).document(bookID).setData(docData){ error in
            if let error = error {
                print("DEBUG: Error sending post - \(error.localizedDescription)")
                return
            }
            print(error ?? "Succeded sending post")
        }
    }
    
    static func getFollowingsPosts(completion: @escaping([UserPostArrayModel]?,String?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        var userPosts: [UserPostArrayModel] = []
        
        FOLLOWING_COLLECTION.document(currentUserUID).collection(USER_FOLLOWING_COLLECTION).getDocuments { documentSnapshot, error in
            if let error = error {
                print("DEBUG: Error retrieving reviews - \(error.localizedDescription)")
                completion(nil, error.localizedDescription)
                return
            }
            guard let data = documentSnapshot else { return }
            let followed_users = data.documents.map ({ $0.documentID})
            
            var count = 0
            for user in followed_users {
                UserService.getUserInfo(uid: user) { userModel, error in
                    if let error = error {
                        print("DEBUG: Error retrieving reviewers - \(error)")
                        completion(nil, error)
                        return
                    }
                    guard let userModel = userModel else {
                        return
                    }
                    
                    getUserPosts(uid: userModel.uid) { posts, error in
                        if let error = error {
                            print("DEBUG: Error retrieving posts - \(error)")
                            completion(nil, error)
                            return
                        }
                        guard let posts = posts else {
                            return
                        }
                        userPosts.append(UserPostArrayModel(post: posts, user: userModel))
                        count += 1
                        if count == followed_users.count {
                            completion(userPosts, nil)
                        }
                    }
                }
            }
        }
        
    }
    
    
    static func getUserPosts(uid: String, completion: @escaping(([PostModel]?, String?) -> Void)) {
        POSTS_COLLECTION.document(uid).collection(USER_POSTS_COLLECTION).getDocuments{ documentSnapshot, error in
            if let error = error {
                print("DEBUG: Error retrieving posts - \(error.localizedDescription)")
                completion(nil, error.localizedDescription)
                return
            }
            guard let data = documentSnapshot else { return }
            let posts = data.documents.map ({ PostModel(dictionary: $0.data(), uid: uid, bookID: $0.documentID) })
            completion(posts, nil)
        }
    }
    
    static func uploadPhoto(image: UIImage, completion: @escaping(String?, Error?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/user_image/\(filename)")
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                completion(nil, error)
            }
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl,nil)
            }
        }
    }
    
}

