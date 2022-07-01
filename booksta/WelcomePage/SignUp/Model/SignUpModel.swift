//
//  SignUpModel.swift
//  booksta
//
//  Created by Catalina Besliu on 23.02.2022.
//

import Foundation


struct SignUpModel {
    let email: String
    let username: String
    let password: String
    let repeatedPassword: String
    let admin: Bool = false
    let booksRead: [String] = []
    let categories: [String] = []
    let imageURL: String = ""
}
