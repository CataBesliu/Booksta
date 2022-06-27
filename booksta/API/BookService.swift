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
    
    static func getBook(bookID: String, completion: @escaping(BookModel?,String?) -> Void) {
        BOOKS_COLLECTION
            .document(bookID)
            .getDocument(completion: { documentSnapshot, error in
                if let error = error {
                    print("DEBUG: Error retrieving books - \(error.localizedDescription)")
                    completion(nil, error.localizedDescription)
                    return
                }
                guard let doc = documentSnapshot else { return }
                if doc.exists, let data = doc.data() {
                    let book = BookModel(dictionary: data, id: doc.documentID)
                completion(book, nil)
                }
            })
    }
    
    static func getBookGenres(completion: @escaping([String]?,String?) -> Void) {
        var genres: [String] = []
        var count = 0
        BOOKS_COLLECTION
            .getDocuments { documentSnapshot, error in
                if let error = error {
                    print("DEBUG: Error retrieving books - \(error.localizedDescription)")
                    completion(nil, error.localizedDescription)
                    return
                }
                guard let data = documentSnapshot else { return }
                let books = data.documents.map ({ BookModel(dictionary: $0.data(), id: $0.documentID) })
                let max = books.count
                if max == 0 {
                    completion(genres, nil)
                }
                for book in books {
                    count += 1
                    for genre in book.genres {
                        if !genres.contains(genre) {
                            genres.append(genre)
                        }
                    }
                    if count == max {
                        completion(genres, nil)
                    }
                }
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
