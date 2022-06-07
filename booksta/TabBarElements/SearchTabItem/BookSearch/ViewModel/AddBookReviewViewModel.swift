//
//  BookViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 29.05.2022.
//

import SwiftUI
import Firebase

class AddBookReviewViewModel: ObservableObject {
    @Published var state = DataState<[BookModel]>.idle
    var book: BookModel
    @Published var hasUserSentReview = false
    @Published var bookReview: ReviewModel?
    
    init(book: BookModel) {
        self.book = book
    }
    
    func hasUserSentReviewFunction(bookID: String) {
        ReviewService.hasUserSentReview(bookID: bookID) { data, error in
            if let review = data.0 {
                self.bookReview = review
            }
            if let hasSent = data.1 {
                //TODO: add self
                self.hasUserSentReview = hasSent
            }
            //TODO: implementat eroarea
            if let error = error {
                
            }
        }
    }
    
    func sendReview(reviewGrade: Int,
                    reviewDescription: String) {
        ReviewService.sendReview(bookID: "\(book.id)",
                                 reviewGrade: reviewGrade,
                                 reviewDescription: reviewDescription) { [weak self] error in
            guard let `self` = self else { return }
            if let error = error {
//                self.state = .error(error)
            } else {
            }
        }
        hasUserSentReviewFunction(bookID:"\(book.id)")
    }
    
}
