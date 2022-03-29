//
//  ProfileViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 23.02.2022.
//

import Foundation
import Firebase

class ProfileViewModel: ObservableObject {
    @Published var state = DataState<UserModel>.idle
    @Published var isUserLoggedIn: Bool = false
    @Published var user: UserModel? {
        didSet {
            
        }
    }
    
    @Published var imageState = DataState<String>.idle
    
    
    func getUserInformation() {
        guard state == .idle else {
            return
        }
        
        state = .loading
        
        UserService.getUserInfo { [weak self] user,error in
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
