//
//  BookService.swift
//  booksta
//
//  Created by Catalina Besliu on 29.03.2022.
//

import Foundation
import Firebase

struct BookService {
    
    static func getBooks(searchField: String = "", limit: Int = 20, completion: @escaping([BookModel]?,String?) -> Void) {
        if searchField.isEmpty {
            BOOKS_COLLECTION
                .limit(to: limit)
                .getDocuments { documentSnapshot, error in
                // documentSnapshot data returns a nsdictionary
                if let error = error {
                    print("DEBUG: Error retrieving books - \(error.localizedDescription)")
                    completion(nil, error.localizedDescription)
                    return
                }
                guard let data = documentSnapshot else { return }
                let books = data.documents.map ({ BookModel(dictionary: $0.data(), id: $0.documentID) })
                completion(books, nil)
            }
        } else {
            BOOKS_COLLECTION
                .whereField("title", isGreaterThanOrEqualTo: searchField)
                .limit(to: limit)
                .getDocuments { documentSnapshot, error in
                // documentSnapshot data returns a nsdictionary
                if let error = error {
                    print("DEBUG: Error retrieving books - \(error.localizedDescription)")
                    completion(nil, error.localizedDescription)
                    return
                }
                guard let data = documentSnapshot else { return }
                let books = data.documents.map ({ BookModel(dictionary: $0.data(), id: $0.documentID) })
                completion(books, nil)
            }
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
