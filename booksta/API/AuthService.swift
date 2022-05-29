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
            
            let data: [String: Any] = ["email": credentials.email,
                                       "uid":uid,
                                       "imageURL":"",
                                       "admin": false ]
            
            USERS_COLLECTION.document(uid).setData(data, completion: completion)
        }
    }
}
