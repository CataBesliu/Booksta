//
//  PostService.swift
//  booksta
//
//  Created by Catalina Besliu on 17.06.2022.
//

import Foundation
import Firebase

struct PostService {
    
//    static func getReviews(bookID: String, completion: @escaping([ReviewerModel]?,String?) -> Void) {
//        var returnList: [ReviewerModel] = []
//        REVIEWS_COLLECTION.document(bookID).collection(USER_REVIEWS_COLLECTION).getDocuments { documentSnapshot, error in
//            if let error = error {
//                print("DEBUG: Error retrieving reviews - \(error.localizedDescription)")
//                completion(nil, error.localizedDescription)
//                return
//            }
//            guard let data = documentSnapshot else { return }
//            let reviews = data.documents.map ({ ReviewModel(dictionary: $0.data(), id: $0.documentID) })
//
//            var count = 0
//            for review in reviews {
//                UserService.getUserInfo(uid: review.id) { user, error in
//                    if let error = error {
//                        print("DEBUG: Error retrieving reviewers - \(error)")
//                        completion(nil, error)
//                        return
//                    }
//                    guard let user = user else {
//                        return
//                    }
//                    count += 1
//                    returnList.append(ReviewerModel(user: user, review: review))
//
//                    if count == reviews.count {
//                        completion(returnList, nil)
//                    }
//                }
//            }
//        }
//    }
    
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
    
//    static func hasUserSentReview(bookID: String, completion: @escaping((ReviewModel?,Bool?), String?) -> Void) {
//        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
//        REVIEWS_COLLECTION.document(bookID).collection(USER_REVIEWS_COLLECTION).document(currentUserUID).getDocument { documentSnapshot, error in
//
//            if let error = error {
//                print("DEBUG: Error retrieving review - \(error.localizedDescription)")
//                completion((nil, nil), error.localizedDescription)
//                return
//            }
//            guard let doc = documentSnapshot else { return }
//            if doc.exists, let data = doc.data() {
//                let review = ReviewModel(dictionary: data, id: doc.documentID)
////                let review = ReviewModel(dictionary: data, id: doc.documentID)
//                completion((review, doc.exists),nil)
//            } else {
//                completion((nil, doc.exists),nil)
//            }
//        }
//    }
    
}

