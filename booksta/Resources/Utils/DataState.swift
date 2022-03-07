//
//  DataState.swift
//  booksta
//
//  Created by Catalina Besliu on 07.03.2022.
//

import Foundation
import CoreMedia

enum DataState<T: Equatable>: Equatable {
case idle
case loading
case loaded(T)
case error(String)
    
    init<Type>(dataState: DataState<Type>) {
        self = .idle
        switch dataState {
        case .idle:
            self = .idle
        case .loading :
            self = .loading
        case let .loaded(data):
            self = .loaded(data as! T)
        case let .error(errorDescription):
            self = .error(errorDescription)
    
        }
    }
}
