//
//  NewApp.swift
//  booksta
//
//  Created by Catalina Besliu on 18.02.2022.
//

import SwiftUI
import Firebase
import Resolver

@main
struct NewApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var isPresentingTabView = false
    @ObservedObject var viewModel: MainProfileViewModel = Resolver.resolve()
    var mainCheck: MainCheck = MainCheck()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(mainCheck)
                .onAppear {
                    viewModel.checkIfUserIsLoggedIn()
                }
                .fullScreenCover(isPresented: $isPresentingTabView) {
                    TabBarView()
                        .environmentObject(mainCheck)
                }
                .onReceive(viewModel.$isUserLoggedIn) { result in
                    self.isPresentingTabView = result
                }
                .onReceive(mainCheck.$logout) { result in
                    self.isPresentingTabView = !result
                }
                .onReceive(mainCheck.$login) { result in
                    self.isPresentingTabView = result
                }
        }
    }
}
