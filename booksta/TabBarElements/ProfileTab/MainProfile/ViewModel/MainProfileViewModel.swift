//
//  ProfileViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 23.02.2022.
//

import Foundation
import Firebase
import Resolver

class MainProfileViewModel: ObservableObject {
    @Published var state = DataState<UserModel>.idle
    @Published var isUserLoggedIn: Bool = false
    @Published var user: UserModel? {
        didSet {
            getUserBooks()
            getUserReviews()
        }
    }
    
    @Published var imageState = DataState<String>.idle
    @Published var books: [BookModel]?
    @Published var reviews: [ReviewModel]?
    
    
    func getUserInformation() {
        guard state == .idle else {
            return
        }
        
        state = .loading
        
        UserService.getCurrentUserInfo { [weak self] user,error in
            guard let `self` = self else { return }
            if let error = error {
                self.state = .error(error)
            } else if let user = user {
                self.state = .loaded(user)
                self.imageState = .loaded(user.imageURL)
                self.user = user
            }
        }
    }
    
    func getUserBooks() {
        UserService.getBooksRead(user) { [weak self] books,error in
            guard let `self` = self else { return }
            if let error = error {
                print(error)
            } else if let books = books {
                self.books = books
            }
        }
    }
    
    func getUserReviews() {
        if let uid = user?.uid {
            ReviewService.getReviewsForUser(userID: uid) { [weak self] reviews,error in
                guard let `self` = self else { return }
                if let error = error {
                    print(error)
                } else if let reviews = reviews {
                    self.reviews = reviews
                }
            }
        }
    }
    
    func uploadPhoto(image: UIImage?) {
        guard imageState == .idle else {
            return
        }
        
        imageState = .loading
        
        if let image = image, let user = user {
            UserService.uploadPhoto(uid: user.uid, image: image, completion: { [weak self] urlImage in
                guard let `self` = self else { return }
                self.imageState = .loaded(urlImage)
            })
        } else {
            self.state = .error("Unable to load image")
        }
    }
    
    func resetImageState() {
        self.imageState = .idle
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            Resolver.reset()
            self.state = .idle
            self.user = nil
            checkIfUserIsLoggedIn()
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    func checkIfUserIsLoggedIn() {
        let user = Auth.auth().currentUser
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.isUserLoggedIn = user != nil
            UserDefaults.standard.set(user?.email, forKey: "email")
        }
    }
}
//        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
