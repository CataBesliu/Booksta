//
//  ProfileViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 23.02.2022.
//

import Foundation
import Firebase
import Resolver
import SwiftUI
class MainProfileViewModel: ProfileViewModel {
    @Published var imageState = DataState<String>.idle
    @Published var user: UserModel? {
        didSet {
            if let user = user {
                UserDefaults.standard.set(user.uid, forKey: "userID")
            }
            getProfileInformation()
        }
    }
    @Published var isUserLoggedIn: Bool = false
    
    func getUserInformation() {
        guard state == .idle else {
            return
        }
        state = .loading
        imageState = .loading
        
        UserService.getCurrentUserInfo { [weak self] user,error in
            guard let `self` = self else { return }
            if let error = error {
                self.state = .error(error)
                self.imageState = .error(error)
            } else if let user = user {
                self.state = .loaded(user)
                self.imageState = .loaded(user.imageURL)
                self.user = user
            }
        }
    }
    
    func getUserPhoto() {
        guard imageState == .idle else {
            return
        }
        imageState = .loading
        
        UserService.getCurrentUserInfo { [weak self] user,error in
            guard let `self` = self else { return }
            if let error = error {
                self.imageState = .error(error)
            } else if let user = user {
                self.imageState = .loaded(user.imageURL)
                self.user = user
                self.state = .loaded(user)
            }
        }
    }
    
    func getProfilePhoto() {
        imageState = .idle
        getUserPhoto()
    }
    
    func getProfileInformation() {
        if let user = user {
            getProfileInformation(user: user)
        }
    }
    
    func logOut(logout: Binding<Bool>) {
        do {
            try Auth.auth().signOut()
            self.state = .idle
            self.user = nil
            checkIfUserIsLoggedIn(logout: logout)
            Resolver.reset()
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    func checkIfUserIsLoggedIn(logout: Binding<Bool> = Binding.constant(false)) {
        let user = Auth.auth().currentUser
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.isUserLoggedIn = user != nil
            if self.isUserLoggedIn == false {
                logout.wrappedValue = true
            }
        }
    }
}
