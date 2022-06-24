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
    
    var body: some Scene {
        WindowGroup {
                HomeView()
                .onAppear {
                    var handle = Auth.auth().addStateDidChangeListener { auth, user in
                        if let user = user
                    }
//                    viewModel.checkIfUserIsLoggedIn()
                }
                .onDisappear {
                    Auth.auth().removeStateDidChangeListener(handle!)
                }
                    .fullScreenCover(isPresented: $isPresentingEditView, content: TabBarView.init)
                    .onReceive(viewModel.$isUserLoggedIn) { result in
                        self.isPresentingEditView = result
                
            }
        }
    }
}
