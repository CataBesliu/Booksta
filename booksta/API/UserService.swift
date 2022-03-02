//
//  UserService.swift
//  booksta
//
//  Created by Catalina Besliu on 02.03.2022.
//

import Foundation
import Firebase

struct UserService {
    static func getUserInfo(completion: @escaping(UserModel) -> Void) {
        // Gets current user uid
        guard let uid = Auth.auth().currentUser?.uid else { return }
        USERS_COLLECTION.document(uid).getDocument { documentSnapshot, error in
            // documentSnapshot data returns a nsdictionary
            if let error = error {
                print("DEBUG: Error retrieving document - \(error.localizedDescription)")
                return
            }
            guard let data = documentSnapshot?.data() else { return }
            print("DEBUG: Document succesfully retrieved")
            
            let user = UserModel(dictionary: data)
            completion(user)
            
        }
    }
}
