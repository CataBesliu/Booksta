//
//  NewApp.swift
//  booksta
//
//  Created by Catalina Besliu on 18.02.2022.
//

import SwiftUI

@main
struct NewApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
