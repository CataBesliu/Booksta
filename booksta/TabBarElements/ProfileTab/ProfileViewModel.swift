//
//  ProfileViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 21.06.2022.
//

import Foundation
import Firebase
import Resolver

class ProfileViewModel: ObservableObject {
    @Published var state = DataState<UserModel>.idle
    @Published var books: [BookModel]?
    @Published var reviews: [ReviewModel]?
    
    func getUserBooks(user: UserModel) {
        UserService.getBooksRead(user) { [weak self] books,error in
            guard let `self` = self else { return }
            if let error = error {
                print(error)
            } else if let books = books {
                self.books = books
            }
        }
    }
    
    func getUserReviews(user: UserModel) {
        ReviewService.getReviewsForUser(userID: user.uid) { [weak self] reviews,error in
                guard let `self` = self else { return }
                if let error = error {
                    print(error)
                } else if let reviews = reviews {
                    self.reviews = reviews
                }
            }
    }
}
