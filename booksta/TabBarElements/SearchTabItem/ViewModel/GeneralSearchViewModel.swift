//
//  GeneralSearchViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 30.06.2022.
//

import Foundation

class GeneralSearchViewModel: ObservableObject {
    @Published var selectedGenres: [String] = [] {
        didSet {
            getGenres()
        }
    }
    @Published var selectedAuthors: [String] = [] {
        didSet {
            getAuthors()
        }
    }
    
    @Published var displayedGenres: [String] = []
    @Published var displayedAuthors: [String] = []
    
    @Published var genreSearchText: String = "" {
        didSet {
            getGenres()
        }
    }
    @Published var authorSearchText: String = "" {
        didSet {
            getAuthors()
        }
    }
    
    var genres: [String] = []
    var authors: [String] = []
    
    func fetchFilters() {
        BookService.getBookGenres { [weak self] genres, error in
            guard let `self` = self else { return }
            if let error = error {
                //
            } else if let genres = genres {
                self.genres = genres
                self.displayedGenres = genres
                self.getGenres()
            }
        }
        BookService.getBookAuthors { [weak self] authors, error in
            guard let `self` = self else { return }
            if let error = error {
                //
            } else if let authors = authors {
                self.authors = authors
                self.displayedAuthors = authors
                self.getAuthors()
            }
        }
    }
    
    func getGenres() {
        var returnValue: [String] = []
        for genre in genres {
            if !selectedGenres.contains(genre) {
                returnValue.append(genre)
            }
        }
        displayedGenres = returnValue.filter({ genreSearchText.isEmpty ? true : $0.lowercased().contains(genreSearchText.lowercased()) })
            .sorted(by: < )
    }
    
    func getAuthors() {
        var returnValue: [String] = []
        for author in authors {
            if !selectedAuthors.contains(author) {
                returnValue.append(author)
            }
        }
        displayedAuthors = returnValue.filter({ authorSearchText.isEmpty ? true : $0.lowercased().contains(authorSearchText.lowercased()) })
            .sorted(by: < )
    }
    
    func updateSearchGenres(genres: [String]) {
        for genre in genres {
            if !selectedGenres.contains(genre) {
                selectedGenres.append(genre)
            }
        }
    }
    
    func updateSearchAuthors(authors: [String]) {
        for author in authors {
            if !selectedAuthors.contains(author) {
                selectedAuthors.append(author)
            }
        }
    }
    
    func changeState() {
        
    }
    
    func resetState() {
        
    }
}

