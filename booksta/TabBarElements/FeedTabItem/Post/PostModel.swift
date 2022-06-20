//
//  PostModel.swift
//  booksta
//
//  Created by Catalina Besliu on 17.06.2022.
//

import Firebase
import Foundation

struct PostModel: Hashable, Equatable {
    let uid: String
    let bookID: String
    let bookName: String
    let description: String
    let imageURL: String
    let comments: [String]
    let likes: [String]
    let timestamp: Date?
    
    init(dictionary: [String: Any], uid: String, bookID: String) {
        self.uid = uid
        self.bookID = bookID
        self.bookName = dictionary["bookName"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.timestamp = PostModel.getDate(data: dictionary["timestamp"] as? String ?? "")
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.comments = dictionary["comments"] as? [String] ?? []
        self.likes = dictionary["likes"] as? [String] ?? []
    }
    
    static func getDate(data: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        if let date = dateFormatter.date(from: data) {
            return date
        } else {
            return nil
        }
    }
}


struct UserPostArrayModel: Hashable, Equatable {
    let post: [PostModel]
    let user: UserModel
    
    init(post: [PostModel], user: UserModel) {
        self.user = user
        self.post = post
    }
}

struct UserPostModel: Hashable, Equatable {
    let post: PostModel
    let user: UserModel
    
    init(post: PostModel, user: UserModel) {
        self.user = user
        self.post = post
    }
}
