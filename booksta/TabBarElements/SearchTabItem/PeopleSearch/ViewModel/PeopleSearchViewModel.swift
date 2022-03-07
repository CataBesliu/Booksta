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
                    self.state = .loaded(users)
                    self.listOfPeople = users
                } else {
                    var list = self.getFilteredList(unfilteredList: users, searchText: searchTerm)
                    self.state = .loaded(list)
                    self.listOfPeople = list
                }
            }
        }
    }
    
    func getFilteredList(unfilteredList: [UserModel], searchText: String) -> [UserModel] {
        return unfilteredList.filter({ searchText.isEmpty ? true : $0.email.contains(searchText) })
    }
    
}
