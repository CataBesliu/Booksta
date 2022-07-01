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
    @State var isPresentingEditView = false
    @ObservedObject var viewModel: MainProfileViewModel = Resolver.resolve()
    var logoutMainCheck: LogoutMainCheck = LogoutMainCheck()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(logoutMainCheck)
                .onAppear {
                    viewModel.checkIfUserIsLoggedIn()
                }
                .fullScreenCover(isPresented: $isPresentingEditView) {
                    TabBarView()
                        .environmentObject(logoutMainCheck)
                }
                .onReceive(viewModel.$isUserLoggedIn) { result in
                    self.isPresentingEditView = result
                }
                .onReceive(logoutMainCheck.$logout) { result in
                    self.isPresentingEditView = !result
                }
        }
    }
}
