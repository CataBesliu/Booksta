//
//  AuthService.swift
//  booksta
//
//  Created by Catalina Besliu on 23.02.2022.
//

import Foundation
import Firebase
import SwiftUI

struct AuthService {
    
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback? ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credentials: SignUpModel, completion: @escaping(Error?) -> Void) {
        print("DEBUG: Credentials are \(credentials)")
        
        //image bla bla
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result,error) in
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription) ")
                return
            }
            
            //Firestore creates the uid
            guard let uid = result?.user.uid else { return }
            let categories: [String] = []
            
            let data: [String: Any] = ["email": credentials.email,
                                       "uid":uid,
                                       "imageURL":"",
                                       "admin": false,
                                       "booksRead": credentials.booksRead,
                                       "username": credentials.username,
                                       "categories": categories]
            
            let publicData: [String: Any] = ["email": credentials.email,
                                             "username": credentials.username]
            
            USERS_COLLECTION.document(uid).setData(data, completion: completion)
            let randomId = Firebase.UUID().uuidString
            PUBLIC_COllECTION.document(randomId).setData(publicData, completion: completion)
        }
    }
    
    static func checkIfEmailIsTaken(email: String, completion: @escaping(Bool?, String?) -> Void) {
        PUBLIC_COllECTION
            .whereField("email", isEqualTo: email)
            .getDocuments { snapshot, error in
                if let err = error {
                    completion(nil, "DEBUG: Error verifying email")
                } else if let snapshot = snapshot {
                    if snapshot.isEmpty {
                        completion(false,nil)
                    }
                    else {
                        completion(true,nil)
                    }
                }
            }
    }
    
    static func checkIfUsernameIsTaken(username: String, completion: @escaping(Bool?, String?) -> Void) {
        PUBLIC_COllECTION
            .whereField("username", isEqualTo: username)
            .getDocuments { snapshot, error in
                if let err = error {
                    completion(nil, "DEBUG: Error verifying username")
                } else if let snapshot = snapshot {
                    if snapshot.isEmpty {
                        completion(false,nil)
                    }
                    else {
                        completion(true,nil)
                    }
                }
            }
    }
}
