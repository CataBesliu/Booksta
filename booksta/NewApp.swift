//
//  NewApp.swift
//  booksta
//
//  Created by Catalina Besliu on 18.02.2022.
//

import SwiftUI
import Firebase

@main
struct NewApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            checkIfUserIsLoggedIn()
        }
    }
    
    func checkIfUserIsLoggedIn() -> some View {
        //DispatchQueue.main.async {
        if Auth.auth().currentUser == nil {
            return HomeView()
                .eraseToAnyView()
        } else {
            return ProfileView()
                .eraseToAnyView()
        }
    }

}
