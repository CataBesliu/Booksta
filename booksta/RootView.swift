//
//  RootView.swift
//  booksta
//
//  Created by Catalina Besliu on 28.02.2022.
//

import Foundation
import SwiftUI

enum ViewDisplayed {
    case homeView
    case tabBarView
}

class Router: ObservableObject {
    @Published var topView: ViewDisplayed = .homeView
    
    static let shared = Router()
}

struct MainView: View {
    @EnvironmentObject var router: Router
    var body: some View {
        VStack {
            switch router.topView {
            case .homeView:
                HomeView()
            case .tabBarView:
                TabBarView()
            }
        }
    }
}
