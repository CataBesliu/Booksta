//
//  UserService.swift
//  booksta
//
//  Created by Catalina Besliu on 02.03.2022.
//

import Foundation
import Firebase
//A completion handler received from Firestore
typealias FirestoreTypeCompletion = (Error?) -> Void

struct UserService {
    
    static func uploadPhoto(uid: String, image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/user_image/\(filename)")
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                USERS_COLLECTION.document(uid).updateData(["imageURL" : imageUrl])
                completion(imageUrl)
            }
        }
    }
    
    static func getCurrentUserInfo(completion: @escaping(UserModel?, String?) -> Void) {
        // Gets current user uid
        guard let uid = Auth.auth().currentUser?.uid else { return }
        USERS_COLLECTION.document(uid).getDocument { documentSnapshot, error in
            // documentSnapshot data returns a nsdictionary
            if let error = error {
                print("DEBUG: Error retrieving document - \(error.localizedDescription)")
                completion(nil,error.localizedDescription)
                return
            }
            guard let data = documentSnapshot?.data() else { return }
            print("DEBUG: Document succesfully retrieved")
            
            let user = UserModel(dictionary: data)
            completion(user, nil)
            
        }
    }
    
    //    static func getUserReviewsInfo(listOfUIDs: [String], completion: @escaping([UserModel]?, String?) -> Void) {
    //        var users: [UserModel] = []
    //        for uid in listOfUIDs {
    //            USERS_COLLECTION.document(uid).getDocument { documentSnapshot, error in
    //                // documentSnapshot data returns a nsdictionary
    //                if let error = error {
    //                    print("DEBUG: Error retrieving document - \(error.localizedDescription)")
    //                    completion(nil, error.localizedDescription)
    //                    return
    //                }
    //                guard let data = documentSnapshot?.data() else { return }
    //                print("DEBUG: Document succesfully retrieved")
    //
    //                let user = UserModel(dictionary: data)
    //                users.append(user)
    //
    //            }
    //        }
    //        completion(users, nil)
    //    }
    
    static func getUserInfo(uid: String, completion: @escaping(UserModel?, String?) -> Void) {
        USERS_COLLECTION.document(uid).getDocument { documentSnapshot, error in
            // documentSnapshot data returns a nsdictionary
            if let error = error {
                print("DEBUG: Error retrieving document - \(error.localizedDescription)")
                completion(nil, error.localizedDescription)
                return
            }
            guard let data = documentSnapshot?.data() else { return }
            print("DEBUG: Document succesfully retrieved")
            
            let user = UserModel(dictionary: data)
            completion(user, nil)
        }
    }
    
    
    
    static func getUsers(limit: Int = 20, completion: @escaping([UserModel]?,String?) -> Void) {
        // Gets current user uid
        USERS_COLLECTION.limit(to: limit)
            .getDocuments { documentSnapshot, error in
                // documentSnapshot data returns a nsdictionary
                if let error = error {
                    print("DEBUG: Error retrieving users - \(error.localizedDescription)")
                    completion(nil, error.localizedDescription)
                    return
                }
                guard let data = documentSnapshot else { return }
                
                let users = data.documents.map ({ UserModel(dictionary: $0.data()) })
                print("DEBUG: Users succesfully retrieved")
                
                completion(users, nil)
                
            }
    }
    //TODO: add time of following?
    static func followUser(userToBeFollowedUID: String, completion: @escaping(FirestoreTypeCompletion)) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        FOLLOWING_COLLECTION.document(currentUserUID).collection(USER_FOLLOWING_COLLECTION).document(userToBeFollowedUID).setData([:]) { error  in
            FOLLOWERS_COLLECTION.document(userToBeFollowedUID).collection(USER_FOLLOWERS_COLLECTION).document(currentUserUID).setData([:], completion: completion )
        }
        
    }
    
    static func unfollowUser(userToBeUnfollowedUID: String, completion: @escaping(FirestoreTypeCompletion)) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        FOLLOWING_COLLECTION.document(currentUserUID).collection(USER_FOLLOWING_COLLECTION).document(userToBeUnfollowedUID).delete { error in
            FOLLOWERS_COLLECTION.document(userToBeUnfollowedUID).collection(USER_FOLLOWERS_COLLECTION).document(currentUserUID).delete(completion: completion)
        }
    }
    
    static func getIsUserFollowed(userCheckedUID: String, completion: @escaping(Bool) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        FOLLOWING_COLLECTION.document(currentUserUID).collection(USER_FOLLOWING_COLLECTION).document(userCheckedUID).getDocument { documentSnapshot, error in
            guard let isUserFollowed = documentSnapshot?.exists else { return }
            completion(isUserFollowed)
        }
    }
    
    static func getUserProperties(uid: String, completion: @escaping(UserProperties) -> Void) {
        FOLLOWING_COLLECTION.document(uid).collection(USER_FOLLOWING_COLLECTION).getDocuments { documentSnapshot, _ in
            let nrFollowing = documentSnapshot?.documents.count ?? 0
            BOOKS_READ_COLLECTION.document(uid).collection(USER_READ_BOOKS_COLLECTION).getDocuments { documentSnapshot, _  in
                let nrBooksRead = documentSnapshot?.documents.count ?? 0
                completion(UserProperties(following: nrFollowing, booksRead: nrBooksRead, review: 0, filters: []))
                //TODO: review and filters
                //                REVIEWS_COLLECTION.document(uid).collection(USER_REVIEWS_COLLECTION).getDocuments { documentSnapshot, _  in
                //                    let reviews = documentSnapshot?.documents.count ?? 0
                //
                //                }
            }
        }
    }
    
    static func hasUserRead(_ bookID: String, completion: @escaping(Bool?, String?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        USERS_COLLECTION
            .whereField("uid", isEqualTo: currentUserUID)
            .whereField("booksRead", arrayContains: bookID)
            .getDocuments { documentSnapshot, error in
                if let error = error {
                    completion(nil, error.localizedDescription)
                }
                else {
                    if documentSnapshot!.documents.count == 0 {
                        completion(false, nil)
                    }
                    for _ in documentSnapshot!.documents {
                        completion(true, nil)
                    }
                    
                }
            }
    }
    
    static func addRemoveBooksRead(_ bookID: String, hasRead: Bool, completion: @escaping(Bool?, String?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        if hasRead {
            USERS_COLLECTION
                .document(currentUserUID)
                .updateData([
                    "booksRead": FieldValue.arrayUnion([bookID])
                ]) { error in
                    if let err = error {
                        completion(nil, err.localizedDescription)
                    } else {
                        completion(true,nil)
                    }
                }
        } else {
            USERS_COLLECTION
                .document(currentUserUID)
                .updateData([
                    "booksRead": FieldValue.arrayRemove([bookID])
                ]) { error in
                    if let err = error {
                        completion(nil, err.localizedDescription)
                    } else {
                        completion(true,nil)
                    }
                }
        }
    }
    
    static func getBooksRead(_ user: UserModel?, completion: @escaping([BookModel]?, String?) -> Void) {
        if let user = user {
            var books: [BookModel] = []
            var count = 0
            var max = user.booksRead.count
            for book in user.booksRead {
                count += 1
                BOOKS_COLLECTION.document(book).getDocument { documentSnapshot, error in
                    if let error = error {
                        completion(nil, error.localizedDescription)
                    } else {
                        guard let doc = documentSnapshot else { return }
                        if doc.exists, let data = doc.data() {
                            let bookModel = BookModel(dictionary: data, id: doc.documentID)
                            books.append(bookModel)
                        }
                        if count == max {
                            completion(books, nil)
                        }
                    }
                }
            }
        }
    }
}
