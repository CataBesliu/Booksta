//
//  Collections.swift
//  booksta
//
//  Created by Catalina Besliu on 02.03.2022.
//

import Firebase

//Will be used to access collections
let USERS_COLLECTION = Firestore.firestore().collection("users")
let FOLLOWERS_COLLECTION = Firestore.firestore().collection("followers")
let FOLLOWING_COLLECTION = Firestore.firestore().collection("following")
let BOOKS_READ_COLLECTION = Firestore.firestore().collection("books-read")
let REVIEWS_COLLECTION = Firestore.firestore().collection("reviews")

let USER_FOLLOWING_COLLECTION = "following-list"
let USER_FOLLOWERS_COLLECTION = "followers-list"
let USER_READ_BOOKS_COLLECTION = "books-read-list"
let USER_REVIEWS_COLLECTION = "reviews-list"
