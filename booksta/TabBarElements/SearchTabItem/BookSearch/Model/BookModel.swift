//
//  BookModel.swift
//  booksta
//
//  Created by Catalina Besliu on 29.03.2022.
//

import Foundation


struct BookModel: Hashable {
    let id: String
    let name: String
    let authors: [String]
    let genres: [String]
    let description: String
    let isbn13: Int
    let subtitle: String
    let publishYear: Int
    let thumbnail: String
    
    let genre: BookGenre
    
    init(dictionary: [String: Any],id: String?) {
        self.id = id ?? ""
        self.name = dictionary["title"] as? String ?? ""
        self.authors = dictionary["authors"] as? [String] ?? []
        self.genres = dictionary["categories"] as? [String] ?? []
        self.description = dictionary["description"] as? String ?? ""
        self.isbn13 = dictionary["isbn13"] as? Int ?? 0
        self.publishYear = dictionary["publish_year"] as? Int ?? 0
        self.subtitle = dictionary["subtitle"] as? String ?? ""
        self.thumbnail = dictionary["thumbnail"] as? String ?? ""
        self.genre = BookGenre(rawValue: dictionary["genre"] as? String ?? "") ?? BookGenre.empty
    }
}

enum BookGenre: String {
    case horror = "horror"
    case scify = "scify"
    case romantic = "romantic"
    case comedy = "comedy"
    case empty = ""
}
