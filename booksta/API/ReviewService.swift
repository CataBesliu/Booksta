//
//  ReviewService.swift
//  booksta
//
//  Created by Catalina Besliu on 07.06.2022.
//

import Foundation
import Firebase

struct ReviewService {
    
    static func getReviewsForUser(userID: String, completion: @escaping([ReviewModel]?,String?) -> Void) {
        var returnList: [ReviewModel] = []
        var count = 0
        USERS_COLLECTION.document(userID).getDocument { documentSnapshot, error in
            if let error = error {
                print("DEBUG: Error retrieving reviews - \(error.localizedDescription)")
                completion(nil, error.localizedDescription)
                return
            }
            guard let doc = documentSnapshot else { return }
            if let data = doc.data(),
               let booksRead = data["booksRead"] as? [String] {
                let max = booksRead.count
                if max == 0 {
                    completion(returnList, nil)
                }
                for book in booksRead {
                    count += 1
                    REVIEWS_COLLECTION.document(book).collection(USER_REVIEWS_COLLECTION).document(userID).getDocument { documentSnapshot2, error2 in
                        if let error = error2 {
                            print("DEBUG: Error retrieving reviews - \(error.localizedDescription)")
                            completion(nil, error.localizedDescription)
                            return
                        }
                        guard let doc = documentSnapshot2 else { return }
                        if doc.exists, let data = doc.data() {
                            let review = ReviewModel(dictionary: data, id: doc.documentID)
                            returnList.append(review)
                            
                        }
                        if count == max {
                            completion(returnList, nil)
                        }
                    }
                }
            }
        }
    }
    
    
    static func getReviews(bookID: String, completion: @escaping([ReviewerModel]?,String?) -> Void) {
        var returnList: [ReviewerModel] = []
        REVIEWS_COLLECTION.document(bookID).collection(USER_REVIEWS_COLLECTION).getDocuments { documentSnapshot, error in
            if let error = error {
                print("DEBUG: Error retrieving reviews - \(error.localizedDescription)")
                completion(nil, error.localizedDescription)
                return
            }
            guard let data = documentSnapshot else { return }
            let reviews = data.documents.map ({ ReviewModel(dictionary: $0.data(), id: $0.documentID) })
            
            var count = 0
            for review in reviews {
                UserService.getUserInfo(uid: review.id) { user, error in
                    if let error = error {
                        print("DEBUG: Error retrieving reviewers - \(error)")
                        completion(nil, error)
                        return
                    }
                    guard let user = user else {
                        return
                    }
                    count += 1
                    returnList.append(ReviewerModel(user: user, review: review))
                    
                    if count == reviews.count {
                        completion(returnList, nil)
                    }
                }
            }
        }
    }
    
    static func sendReview(bookID: String, reviewGrade: Int, reviewDescription: String = "", completion: @escaping(FirestoreTypeCompletion)) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        REVIEWS_COLLECTION.document(bookID).collection(USER_REVIEWS_COLLECTION).document(currentUserUID).setData(
            ["reviewGrade": reviewGrade, "reviewDescription": reviewDescription, "timestamp": getDate()]) { error in
                if let error = error {
                    print("DEBUG: Error retrieving books - \(error.localizedDescription)")
                    return
                }
                print(error ?? "Succeded")
            }
    }
    
    static func hasUserSentReview(bookID: String, completion: @escaping((ReviewModel?,Bool?), String?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        REVIEWS_COLLECTION.document(bookID).collection(USER_REVIEWS_COLLECTION).document(currentUserUID).getDocument { documentSnapshot, error in
            
            if let error = error {
                print("DEBUG: Error retrieving review - \(error.localizedDescription)")
                completion((nil, nil), error.localizedDescription)
                return
            }
            guard let doc = documentSnapshot else { return }
            if doc.exists, let data = doc.data() {
                let review = ReviewModel(dictionary: data, id: doc.documentID)
                //                let review = ReviewModel(dictionary: data, id: doc.documentID)
                completion((review, doc.exists),nil)
            } else {
                completion((nil, doc.exists),nil)
            }
        }
    }
    
    static func getDate() -> String {
        let date = Date()
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
}
