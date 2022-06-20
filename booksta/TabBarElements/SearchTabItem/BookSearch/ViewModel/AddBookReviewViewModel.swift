//
//  BookViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 29.05.2022.
//

import SwiftUI
import Firebase
import Resolver

class AddBookReviewViewModel: ObservableObject {
    @ObservedObject var profileViewModel: MainProfileViewModel = Resolver.resolve()
    @Published var state = DataState<[ReviewerModel]>.idle
    @Published var hasUserSentReview = false
    @Published var bookReview: ReviewModel?
    @Published var isRead: Bool = false {
        didSet {
            UserService.addRemoveBooksRead(book.id, hasRead: isRead) { result, error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    var book: BookModel
    
    init(book: BookModel) {
        self.book = book
    }
    
    func hasUserReadBook() {
        UserService.hasUserRead(book.id) { [weak self] result, error in
            guard let `self` = self else { return }
            if let result = result {
                self.isRead = result
            }
        }
    }
    
    func hasUserSentReviewFunction() {
        ReviewService.hasUserSentReview(bookID: book.id) { [weak self] data, error in
            guard let `self` = self else { return }
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
        hasUserSentReviewFunction()
        state = .idle
        getReviews()
    }
    
    
    func getReviews() {
        guard state == .idle else {
            return
        }
        //        state = .loading
        
        ReviewService.getReviews(bookID: book.id) { [weak self] data, error in
            guard let `self` = self else { return }
            self.state = .loading
            if let error = error {
                self.state = .error(error)
            } else if let reviewers = data {
                self.state = .loaded(reviewers)
            }
        }
    }
    
    func checkFieldsAreCompleted(reviewGrade: String) -> Bool {
        return reviewGrade.isEmpty == false
    }
    
}
