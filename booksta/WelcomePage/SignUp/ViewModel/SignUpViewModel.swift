//
//  SignUpViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 20.02.2022.
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var isEmailTaken = false
    @Published var isUsernameTaken = false
    @Published var isPasswordShort = false
    
    func checkPasswordsMatch(password1: String, password2: String) -> Bool {
        return password1 == password2
    }
    
    func checkFieldsAreCompleted(email: String, password1: String, password2: String) -> Bool {
        return email.isEmpty == false &&
        password1.isEmpty == false &&
        password2.isEmpty == false
    }
    
    func checkEmail(email: String) {
        AuthService.checkIfEmailIsTaken(email: email) {[weak self] result, error in
            guard let `self` = self else { return }
            if let error = error {
                print(error)
            } else if let result = result {
                self.isEmailTaken = result
            }
        }
    }
    
    func checkUsername(username: String) {
        AuthService.checkIfUsernameIsTaken(username: username) {[weak self] result, error in
            guard let `self` = self else { return }
            if let error = error {
                print(error)
            } else if let result = result {
                self.isUsernameTaken = result
            }
        }
    }
    
    func checkPassword(password: String) {
        if password.count < 8 {
            isPasswordShort = true
        } else {
            isPasswordShort = false
        }
    }
}
