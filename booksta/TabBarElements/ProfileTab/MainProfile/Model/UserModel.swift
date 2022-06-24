//
//  UserModel.swift
//  booksta
//
//  Created by Catalina Besliu on 02.03.2022.
//
import Firebase
import Foundation

struct UserModel: Hashable, Equatable {
    let uid: String
    let username: String
    let email: String
    let imageURL: String
    let booksRead: [String]
    let genres: [String]
    let admin: Bool
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.admin = dictionary["admin"] as? Bool ?? false
        self.booksRead = dictionary["booksRead"] as? [String] ?? []
        self.genres = dictionary["categories"] as? [String] ?? []
    }
}
