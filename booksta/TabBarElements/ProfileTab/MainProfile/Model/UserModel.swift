//
//  UserModel.swift
//  booksta
//
//  Created by Catalina Besliu on 02.03.2022.
//

import Foundation

struct UserModel: Hashable {
    let uid: String
    let email: String
//    TODO: let username: String
    let imageURL: String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.imageURL = dictionary["imageURL"] as? String ?? ""
    }
}
