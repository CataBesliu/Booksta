//
//  BookSearchViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 05.05.2022.
//

import Foundation
import Firebase

class BookSearchViewModel: GeneralSearchViewModel {
    @Published var state = DataState<[BookModel]>.idle
    @Published var listOfBooks: [BookModel] = []
    @Published var searchText: String = "" {
        didSet {
            resetState()
            changeState()
        }
    }
    var countOfBooks = 20 {
        didSet {
            resetState()
//            fetchBooks(searchTerm: searchText)
            changeState()
        }
    }
    
    //    func fetchBooks(searchTerm: String) {
    //        guard state == .idle else {
    //            return
    //        }
    //        state = .loading
    //
    //        if searchTerm.isEmpty {
    //            BookService.getBooks(limit: countOfBooks) { [weak self] books, error in
    //                guard let `self` = self else { return }
    //                if let error = error {
    //                    self.state = .error(error)
    //                } else if let books = books {
    //                    self.listOfBooks = self.getFilteredList(unfilteredList: books, searchText: searchTerm)
    //                    //                    self.listOfBooks = []
    //                    self.state = .loaded(self.listOfBooks)
    //                }
    //            }
    //        } else {
    //            BookService.getBooks(searchField: searchTerm, limit: countOfBooks) { [weak self] books, error in
    //                guard let `self` = self else { return }
    //                if let error = error {
    //                    self.state = .error(error)
    //                } else if let books = books {
    ////                    let list = self.getFilteredList(unfilteredList: books, searchText: searchTerm)
    //                    self.state = .loaded(books)
    //                    self.listOfBooks = books
    //
    //                }
    //            }
    //        }
    //    }
    
    func getFilteredList(unfilteredList: [BookModel], searchText: String) -> [BookModel] {
        return unfilteredList.filter({ searchText.isEmpty ? true :
            $0.name.lowercased().contains(searchText.lowercased())})
        
    }
    
    override func changeState() {
        guard state == .idle else {
            return
        }
        state = .loading
        
        BookService.getBooks(searchField: searchText,
                             limit: countOfBooks,
                             genres: selectedGenres,
                             authors: selectedAuthors) { [weak self] books, error in
            guard let `self` = self else { return }
            if let error = error {
                self.state = .error(error)
            } else if let books = books {
                //                    let list = self.getFilteredList(unfilteredList: books, searchText: searchTerm)
                self.state = .loaded(books)
                self.listOfBooks = books
                
            }
        }
    }
    
    override func resetState() {
        state = .idle
    }
}

