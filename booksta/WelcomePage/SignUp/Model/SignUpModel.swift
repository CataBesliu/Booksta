//
//  SignUpModel.swift
//  booksta
//
//  Created by Catalina Besliu on 23.02.2022.
//

import Foundation


struct SignUpModel {
    let email: String
    let password: String
    let repeatedPassword: String
    let booksRead: [String] = []
    let username: String = ""
}
