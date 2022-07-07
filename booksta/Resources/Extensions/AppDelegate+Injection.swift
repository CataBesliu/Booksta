//
//  AppDelegate+Injection.swift
//  booksta
//
//  Created by Catalina Besliu on 24.02.2022.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register{ MainProfileViewModel() }.scope(.application)
        register{ PeopleSearchViewModel() }.scope(.application)
        register{ BookSearchViewModel() }.scope(.application)
        register{ FeedViewModel() }.scope(.application)
        register{ BookRecommenderAPI() }.scope(.application)
        register{ StatisticsViewModel() }.scope(.cached)
        register { EditProfileViewModel() }.scope(.unique)
        register { AddPostViewModel() }.scope(.unique)
    }
}
