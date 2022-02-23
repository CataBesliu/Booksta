//
//  ProfileViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 23.02.2022.
//

import Foundation
import Firebase

class ProfileViewModel: ObservableObject {
    @Published var isUserLoggedIn: Bool?
    
    func checkIfUserIsLoggedIn() {
        isUserLoggedIn = Auth.auth().currentUser != nil
    }
}
