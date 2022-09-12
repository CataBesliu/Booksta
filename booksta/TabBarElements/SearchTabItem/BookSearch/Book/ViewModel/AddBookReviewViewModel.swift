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
    var reviewsListener: ListenerRegistration?
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
    
    func createListener() {
        reviewsListener = REVIEWS_COLLECTION
            .document(book.id)
            .collection(USER_REVIEWS_COLLECTION)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("DEBUG: Error retrieving reviews - \(error.localizedDescription)")
                    self.state = .error(error.localizedDescription)
                    return
                }
                guard let data = documentSnapshot else { return }
                let reviews = data.documents.map ({ ReviewModel(dictionary: $0.data(), id: $0.documentID, bookID: self.book.id) })
                
                var returnList: [ReviewerModel] = []
                var count = 0
                for review in reviews {
                    UserService.getUserInfo(uid: review.id) { user, error in
                        if let error = error {
                            print("DEBUG: Error retrieving reviewers - \(error)")
                            self.state = .error(error)
                            return
                        }
                        guard let user = user else {
                            return
                        }
                        count += 1
                        returnList.append(ReviewerModel(user: user, review: review))
                        
                        if count == reviews.count {
                            self.state = .loaded(returnList)
                        }
                    }
                }
            }
    }
    
    func removeListener() {
        reviewsListener?.remove()
    }
}
