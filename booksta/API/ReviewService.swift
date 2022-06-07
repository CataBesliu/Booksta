//
//  ReviewService.swift
//  booksta
//
//  Created by Catalina Besliu on 07.06.2022.
//

import Foundation
import Firebase

struct ReviewService {
    
    static func sendReview(bookID: String, reviewGrade: Int, reviewDescription: String = "", completion: @escaping(FirestoreTypeCompletion)) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        REVIEWS_COLLECTION.document(bookID).collection(USER_REVIEWS_COLLECTION).document(currentUserUID).setData(
            ["reviewGrade": reviewGrade, "reviewDescription": reviewDescription, "timestamp": ServerValue.timestamp()]) { error in
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
                completion((review, doc.exists),nil)
            } else {
                completion((nil, doc.exists),nil)
            }
        }
    }
}
