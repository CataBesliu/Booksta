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
    
    init(decodedObject: DataDecodable) {
        self.id = decodedObject.id
        self.name = decodedObject.data.title
        self.authors = decodedObject.data.authors
        self.genres = decodedObject.data.categories
        self.description = decodedObject.data.description
        self.isbn13 = decodedObject.data.isbn13
        self.publishYear = decodedObject.data.published_year
        self.subtitle = decodedObject.data.subtitle
        self.thumbnail = decodedObject.data.thumbnail
        self.genre = BookGenre.empty
    }
}

enum BookGenre: String {
    case horror = "horror"
    case scify = "scify"
    case romantic = "romantic"
    case comedy = "comedy"
    case empty = ""
}

struct DataDecodable: Decodable {
    var data: BookModelDecodable
    var id: String
}

struct BookModelDecodable: Decodable {
    var title: String
    var authors: [String]
    var categories: [String]
    var description: String
    var isbn13: Int
    var subtitle: String
    var published_year: Int
    var thumbnail: String
}
