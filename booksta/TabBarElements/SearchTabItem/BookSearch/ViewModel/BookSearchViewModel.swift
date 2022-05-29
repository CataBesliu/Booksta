//
//  BookSearchViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 05.05.2022.
//

import Foundation
import Firebase

class BookSearchViewModel: ObservableObject {
    @Published var state = DataState<[BookModel]>.idle
    @Published var listOfBooks: [BookModel] = []
    @Published var searchText: String = "" {
        didSet {
            state = .idle
            fetchBooks(searchTerm: searchText)
        }
    }
    
    func fetchBooks(searchTerm: String) {
        guard state == .idle else {
            return
        }
        state = .loading
        
        if searchTerm.isEmpty {
            self.listOfBooks = []
            self.state = .loaded(self.listOfBooks)
        } else {
            BookService.getBooks { [weak self] books, error in
                guard let `self` = self else { return }
                if let error = error {
                    self.state = .error(error)
                } else if let books = books {
                    if searchTerm.isEmpty {
                        self.listOfBooks = self.getFilteredList(unfilteredList: books, searchText: searchTerm)
                        //                    self.listOfBooks = []
                        self.state = .loaded(self.listOfBooks)
                    } else {
                        let list = self.getFilteredList(unfilteredList: books, searchText: searchTerm)
                        self.state = .loaded(list)
                        self.listOfBooks = list
                    }
                }
            }
        }
    }
    
    func getFilteredList(unfilteredList: [BookModel], searchText: String) -> [BookModel] {
        return unfilteredList.filter({ searchText.isEmpty ? true :
            $0.name.lowercased().contains(searchText.lowercased())})
        
    }
}

