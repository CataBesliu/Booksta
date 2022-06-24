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
}

