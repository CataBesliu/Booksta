//
//  AddPostViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 17.06.2022.
//

import SwiftUI
import UIKit

class AddPostViewModel: ObservableObject {
    @Published var state = DataState<[BookModel]>.idle
    @Published var imageURL: String = ""
    
    @Published var wasPostSend = false
    @Published var listOfBooks: [BookModel] = []
    @Published var showBooks = true
    @Published var selectedBook: BookModel?
    
    @Published var searchText: String = "" {
        didSet {
            state = .idle
            getBooks(searchTerm: searchText)
            if searchText.isEmpty {
                showBooks = true
            }
        }
    }
    
    private func getBooks(searchTerm: String) {
        guard state == .idle else {
            return
        }
        state = .loading
        
        if searchTerm.isEmpty {
            BookService.getBooks(limit: 5) { [weak self] books, error in
                guard let `self` = self else { return }
                if let error = error {
                    self.state = .error(error)
                } else if let books = books {
                    self.listOfBooks = books
                    self.state = .loaded(books)
                }
            }
        } else {
            BookService.getBooks(searchField: searchTerm, limit: 5) { [weak self] books, error in
                guard let `self` = self else { return }
                if let error = error {
                    self.state = .error(error)
                } else if let books = books {
                    self.state = .loaded(books)
                    self.listOfBooks = books
                }
            }
        }
    }
    
    func sendPost(postDescription: String) {
        let postImageURL = imageURL
        if let selectedBook = selectedBook {
            PostService.sendPost(bookID: selectedBook.id, bookName: selectedBook.name, postDescription: postDescription, postPhoto: postImageURL) { [weak self] error in
                guard let `self` = self else { return }
                if error != nil {
                    self.wasPostSend = false
                } else {
                    self.wasPostSend = true
                }
            }
        }
    }
    
    func uploadPhoto(image: UIImage?) {
        if let image = image {
            PostService.uploadPhoto(image: image) { [weak self] urlImage, error in
                guard let `self` = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                } else if let urlImage = urlImage {
                    self.imageURL = urlImage
                }
            }
        } else {
            print("Unable to load image")
        }
    }
    
    func selectBook(book: BookModel) {
        self.showBooks = false
        self.selectedBook = book
    }
    
    func resetImageState() {
        self.imageURL = ""
    }
}
