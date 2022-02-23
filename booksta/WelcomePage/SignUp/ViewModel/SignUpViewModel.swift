//
//  SignUpViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 20.02.2022.
//

import Foundation

class SignUpViewModel: ObservableObject {
    
    func checkPasswordsMatch(password1: String, password2: String) -> Bool {
        return password1 == password2
    }
    
    func checkFieldsAreCompleted(email: String, password1: String, password2: String) -> Bool {
        return email.isEmpty == false &&
        password1.isEmpty == false &&
        password2.isEmpty == false
    }
}
