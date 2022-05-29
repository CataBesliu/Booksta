//
//  BookViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 29.05.2022.
//

import SwiftUI
import Firebase

class BookViewModel: ObservableObject {
    @Published var state = DataState<[BookModel]>.idle
}
