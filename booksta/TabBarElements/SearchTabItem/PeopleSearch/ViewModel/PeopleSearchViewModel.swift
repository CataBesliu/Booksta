//
//  PeopleSearchViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 07.03.2022.
//

import Foundation
import SwiftUI
import Firebase

class PeopleSearchViewModel: GeneralSearchViewModel {
    @Published var state = DataState<[UserModel]>.idle
    @Published var listOfPeople: [UserModel] = []
    @Published var searchText: String = "" {
        didSet {
            print(searchText)
            resetState()
            changeState()
        }
    }
    
    //    func fetchUsers(searchTerm: String) {
    //        guard state == .idle else {
    //            return
    //        }
    //        state = .loading
    //
    //        UserService.getUsers { [weak self] users,error in
    //            guard let `self` = self else { return }
    //            if let error = error {
    //                self.state = .error(error)
    //            } else if let users = users {
    //                if searchTerm.isEmpty {
    //                    self.listOfPeople = self.getFilteredList(unfilteredList: users, searchText: searchTerm)
    //                    self.state = .loaded(self.listOfPeople)
    //                } else {
    //                    let list = self.getFilteredList(unfilteredList: users, searchText: searchTerm)
    //                    self.state = .loaded(list)
    //                    self.listOfPeople = list
    //                }
    //            }
    //        }
    //    }
    
    func getFilteredList(unfilteredList: [UserModel]) -> [UserModel] {
        let loggedInUserEmail = Auth.auth().currentUser?.email
        return unfilteredList.filter({ $0.email != loggedInUserEmail})
    }
    
    
    override func changeState() {
        guard state == .idle else {
            return
        }
        state = .loading
        
        UserService.getUsers(searchField: searchText, genres: selectedGenres) { [weak self] users,error in
            guard let `self` = self else { return }
            if let error = error {
                self.state = .error(error)
            } else if let users = users {
                let list = self.getFilteredList(unfilteredList: users)
                self.state = .loaded(list)
                self.listOfPeople = list
            }
        }
    }
    
    override func resetState() {
        state = .idle
    }
}
