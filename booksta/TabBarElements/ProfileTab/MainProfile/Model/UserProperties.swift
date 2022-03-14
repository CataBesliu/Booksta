//
//  UserProperties.swift
//  booksta
//
//  Created by Catalina Besliu on 11.03.2022.
//

import SwiftUI

struct UserProperties: Hashable {
    let following: Int
    let booksRead: Int
    //    TODO: let username: String
    let review: Int
    let filters: [String]
    
//    init(dictionary: [String: Any]) {
//        self.uid = dictionary["uid"] as? String ?? ""
//        self.email = dictionary["email"] as? String ?? ""
//        self.imageURL = dictionary["imageURL"] as? String ?? ""
//    }
}

