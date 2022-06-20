//
//  PostViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 19.06.2022.
//

import Foundation
import Firebase

class PostViewModel: ObservableObject {
    @Published var book: BookModel?
    @Published var isBookFetched = false
    
    
    func getBook(bookID: String) {
        BookService.getBook(bookID: bookID) {[weak self] book, error in
            guard let `self` = self else { return }
            if let error = error {
                print(error)
            } else if let book = book {
                self.book = book
                self.isBookFetched = true
            }
        }
    }
}

