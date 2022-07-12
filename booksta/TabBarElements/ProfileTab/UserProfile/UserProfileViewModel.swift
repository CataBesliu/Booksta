//
//  UserProfileViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 09.03.2022.
//

import Foundation
import SwiftUI
import Firebase

class UserProfileViewModel: ProfileViewModel {
    @Published var isFollowedState: Bool = false
    @Published var user: UserModel
    var listener: ListenerRegistration?
    
    init(user: UserModel) {
        self.user = user
    }
    
    func followUser() {
        print("DEBUG: Handling following user")
        state = .loading
        UserService.followUser(userToBeFollowedUID: user.uid) { [weak self] error in
            guard let `self` = self else { return }
            if let error = error {
                self.state = .error(error.localizedDescription)
                return
            }
            self.state = .loaded(self.user)
        }
    }
    
    func unfollowUser() {
        print("DEBUG: Handling unfollowing user")
        state = .loading
        UserService.unfollowUser(userToBeUnfollowedUID: user.uid) {[weak self] error in
            guard let `self` = self else { return }
            if let error = error {
                self.state = .error(error.localizedDescription)
                return
            }
            self.state = .loaded(self.user)
        }
    }
    
    func getIsUserFollowed() {
        print("DEBUG: Checking if the current user if following given user")
        UserService.getIsUserFollowed(userCheckedUID: user.uid) { isUserFollowed in
            self.isFollowedState = isUserFollowed
        }
    }
    
    func fetchUserData() {
        getIsUserFollowed()
        getProfileInformation(user: user)
    }
    
    func createListener() {
        listener = USERS_COLLECTION
            .document(user.uid)
            .addSnapshotListener { documentSnapshot, error in
            // documentSnapshot data returns a nsdictionary
            if let error = error {
                print("DEBUG: Error retrieving document - \(error.localizedDescription)")
                return
            }
            guard let data = documentSnapshot?.data() else { return }
            print("DEBUG: User information succesfully retrieved")
            
            let user = UserModel(dictionary: data)
                self.user = user
        }
            
    }
    
    func removeListener() {
        listener?.remove()
    }
}

