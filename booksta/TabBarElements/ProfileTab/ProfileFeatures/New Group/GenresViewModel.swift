////
////  GenresViewModel.swift
////  booksta
////
////  Created by Catalina Besliu on 26.06.2022.
////
//
//import Foundation
//import SwiftUI
//
//class GenresViewModel: ObservableObject {
//    @Published var allGenres: [String] = [] {
//        didSet {
//            getAvailableGenres()
//        }
//    }
//    @Published var availableGenres: [String] = []
//    @Published var searchText: String = "" {
//        didSet {
//            //            fetch genres
//        }
//    }
//    
//    
//    func getAllGenres(profileGenres: [String]) {
//        BookService.getBookGenres { [weak self] genres, error in
//            guard let self = self else { return }
//            if let error = error {
//                print(error)
//            } else if let genres = genres {
//                self.allGenres = genres
//            }
//        }
//    }
//    
//    func getAvailableGenres(profileGenres: [String]) {
//        var returnValue: [String] = []
//        for genre in allGenres {
//            if !profileGenres.contains(genre) {
//                returnValue.append(genre)
//            }
//        }
//        availableGenres = returnValue
//    }
//    
//    func onUnselect(index: Int) {
//        profileGenres.remove(at: index)
//    }
//    
//    func updateProfileGenres(selectedGenres: [String]) {
//        for genre in selectedGenres {
//            if !profileGenres.contains(genre) {
//                profileGenres.append(genre)
//            }
//        }
//    }
//}
