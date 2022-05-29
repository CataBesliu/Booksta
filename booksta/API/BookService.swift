//
//  BookService.swift
//  booksta
//
//  Created by Catalina Besliu on 29.03.2022.
//

import Foundation
import Firebase

struct BookService {
    
    static func getBooks(completion: @escaping([BookModel]?,String?) -> Void) {
        BOOKS_COLLECTION.getDocuments { documentSnapshot, error in
            // documentSnapshot data returns a nsdictionary
            if let error = error {
                print("DEBUG: Error retrieving books - \(error.localizedDescription)")
                completion(nil, error.localizedDescription)
                return
            }
            guard let data = documentSnapshot else { return }
            let books = data.documents.map ({ BookModel(dictionary: $0.data()) })
            completion(books, nil)
            
        }
    }
    
    //    static func addBook(uid: String, image: UIImage, completion: @escaping([BookModel]?,String?) -> Void) {
    //        BOOKS_COLLECTION.getDocuments { documentSnapshot, error in
    //            // documentSnapshot data returns a nsdictionary
    //            if let error = error {
    //                print("DEBUG: Error retrieving books - \(error.localizedDescription)")
    //                completion(nil, error.localizedDescription)
    //                return
    //            }
    //            guard let data = documentSnapshot else { return }
    //
    //            let users = data.documents.map ({ UserModel(dictionary: $0.data()) })
    //
    //    }
    
}

struct Content: Decodable {
    let title: String
    let subtitle: String
    let authors: String
    let categories: String
    let thumbnail: String
    let description: String
    let published_year: String
    
    
}
