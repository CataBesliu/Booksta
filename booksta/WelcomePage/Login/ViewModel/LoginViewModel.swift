//
//  LoginViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 18.02.2022.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {

    func checkFieldsAreCompleted(email: String, password: String) -> Bool {
        return email.isEmpty == false && password.isEmpty == false
    }

}
