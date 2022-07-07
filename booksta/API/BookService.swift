//
//  BookService.swift
//  booksta
//
//  Created by Catalina Besliu on 29.03.2022.
//

import Foundation
import Firebase

struct BookService {
    
    static func getBooks(searchField: String = "",
                         limit: Int = 20,
                         genres: [String] = [],
                         authors: [String] = [],
                         completion: @escaping([BookModel]?,String?) -> Void) {
        
        var documentReference: Query
        var checkForAuthors = false
        if !searchField.isEmpty && genres.isEmpty && authors.isEmpty {
            documentReference = BOOKS_COLLECTION
                .whereField("title", isGreaterThanOrEqualTo: searchField)
                .limit(to: limit)
        } else if !searchField.isEmpty && !genres.isEmpty && authors.isEmpty {
            documentReference = BOOKS_COLLECTION
                .whereField("title", isGreaterThanOrEqualTo: searchField)
                .whereField("categories", arrayContainsAny: genres)
                .limit(to: limit)
        } else if !searchField.isEmpty && genres.isEmpty && !authors.isEmpty {
            documentReference = BOOKS_COLLECTION
                .whereField("title", isGreaterThanOrEqualTo: searchField)
                .whereField("authors", arrayContainsAny: authors)
                .limit(to: limit)
        } else if !searchField.isEmpty && !genres.isEmpty && !authors.isEmpty {
            documentReference = BOOKS_COLLECTION
                .whereField("title", isGreaterThanOrEqualTo: searchField)
                .whereField("categories", arrayContainsAny: genres)
                .limit(to: 1000)
            checkForAuthors = true
        } else if searchField.isEmpty && !genres.isEmpty && !authors.isEmpty {
            documentReference = BOOKS_COLLECTION
                .whereField("categories", arrayContainsAny: genres)
                .limit(to: 1000)
            checkForAuthors = true
        } else if searchField.isEmpty && genres.isEmpty && !authors.isEmpty {
            documentReference = BOOKS_COLLECTION
                .whereField("authors", arrayContainsAny: authors)
                .limit(to: limit)
        } else if searchField.isEmpty && !genres.isEmpty && authors.isEmpty {
            documentReference = BOOKS_COLLECTION
                .whereField("categories", arrayContainsAny: genres)
                .limit(to: limit)
        } else {
            documentReference = BOOKS_COLLECTION
                .limit(to: limit)
        }
        
        documentReference
            .getDocuments { documentSnapshot, error in
                // documentSnapshot data returns a nsdictionary
                if let error = error {
                    print("DEBUG: Error retrieving books - \(error.localizedDescription)")
                    completion(nil, error.localizedDescription)
                    return
                }
                guard let data = documentSnapshot else { return }
                let books = data.documents.map ({ BookModel(dictionary: $0.data(), id: $0.documentID) })
                var returnBooks: Set<BookModel> = []
                if checkForAuthors && !authors.isEmpty {
                    for author in authors {
                        returnBooks = returnBooks.union(books.filter({$0.authors.contains(author)}))
                    }
                    completion(Array(returnBooks), nil)
                } else {
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
    
    static func getBookAuthors(completion: @escaping([String]?,String?) -> Void) {
        var authors: [String] = []
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
                    completion(authors, nil)
                }
                for book in books {
                    count += 1
                    for author in book.authors {
                        if !authors.contains(author) {
                            authors.append(author)
                        }
                    }
                    if count == max {
                        completion(authors, nil)
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
