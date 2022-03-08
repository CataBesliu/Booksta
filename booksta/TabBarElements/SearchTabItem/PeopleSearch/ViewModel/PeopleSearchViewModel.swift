//
//  PeopleSearchViewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 07.03.2022.
//

import Foundation
import SwiftUI

class PeopleSearchViewModel: ObservableObject {
    @Published var state = DataState<[UserModel]>.idle
    @Published var listOfPeople: [UserModel] = []
    @Published var searchText: String = "" {
        didSet {
            state = .idle
            fetchUsers(searchTerm: searchText)
        }
    }
    
    func fetchUsers(searchTerm: String) {
        guard state == .idle else {
            return
        }
        
        state = .loading
        
        UserService.getUsers { [weak self] users,error in
            guard let `self` = self else { return }
            if let error = error {
                self.state = .error(error)
            } else if let users = users {
                if searchTerm.isEmpty {
                    self.listOfPeople = self.getFilteredList(unfilteredList: users, searchText: searchTerm)
                    self.state = .loaded(self.listOfPeople)
                } else {
                    let list = self.getFilteredList(unfilteredList: users, searchText: searchTerm)
                    self.state = .loaded(list)
                    self.listOfPeople = list
                }
            }
        }
    }
    
    func getFilteredList(unfilteredList: [UserModel], searchText: String) -> [UserModel] {
        let loggedInUserEmail = UserDefaults.standard.string(forKey: "email")
        return unfilteredList.filter({ searchText.isEmpty ? $0.email != loggedInUserEmail :
            $0.email.lowercased().contains(searchText.lowercased()) &&
            $0.email != loggedInUserEmail })
    }
    
}
