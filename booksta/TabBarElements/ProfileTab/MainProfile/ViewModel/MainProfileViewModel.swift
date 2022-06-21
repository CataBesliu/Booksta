//
//  ProfileViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 23.02.2022.
//

import Foundation
import Firebase
import Resolver

class MainProfileViewModel: ProfileViewModel {
//    @Published var state = DataState<UserModel>.idle
    @Published var imageState = DataState<String>.idle
//    @Published var books: [BookModel]?
//    @Published var reviews: [ReviewModel]?
    @Published var user: UserModel? {
        didSet {
            getUserBooks()
            getUserReviews()
        }
    }
    @Published var isUserLoggedIn: Bool = false
    
    
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
        if let user = user {
            getUserBooks(user: user)
        }
    }
    
    func getUserReviews() {
        if let user = user {
            getUserReviews(user: user)
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
        }
    }
}
