//
//  TabBarView.swift
//  booksta
//
//  Created by Catalina Besliu on 25.02.2022.
//

import SwiftUI
import Firebase
import Resolver

struct TabBarView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var logoutMainCheck: LogoutMainCheck
    @ObservedObject var viewModel: MainProfileViewModel = Resolver.resolve()
    @State private var selection = 0
    var body: some View {
        GeometryReader { _ in
        TabView(selection: $selection) {
            FeedView()
                .tabItem {
                    Label("Home", systemImage: "house.circle.fill")
                }
                .font(.system(.headline, design: .rounded))
                .tag(0)
            
            
            GeneralSearchView()
                .frame(maxWidth: .infinity)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass.circle.fill")
                }
                .font(.system(.headline, design: .rounded))
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
                .font(.system(.headline, design: .rounded))
                .tag(2)
            
            MainProfileView().environmentObject(logoutMainCheck)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .font(.system(.headline, design: .rounded))
                .tag(3)
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = UIColor(named: "bookstaPurple800")
            UITabBar.appearance().barTintColor = UIColor(named: "bookstaPurple800")
            viewModel.getUserInformation()
        }
        .accentColor(.bookstaGrey50)
        .background(Color.bookstaPurple)
        .frame(
            width: UIScreen.main.bounds.width ,
            height: UIScreen.main.bounds.height
        )
        .edgesIgnoringSafeArea(.all)
        .preferredColorScheme(.light)
        }
    }
}


struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
