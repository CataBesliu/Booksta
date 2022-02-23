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
        register{ ProfileViewModel() }.scope(.application)
    }
}
