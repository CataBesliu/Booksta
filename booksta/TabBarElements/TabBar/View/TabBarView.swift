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
    @ObservedObject var viewModel: ProfileViewModel = Resolver.resolve()
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
            
            
            //            Text("Review books")
//            SecondAttempt()
//                .tabItem {
//                    Label("Review", systemImage: "book.closed.circle")
//                }
//                .font(.system(.headline, design: .rounded))
//                .tag(2)
            
//            Text("Add post")
//                .tabItem {
//                    Label("Post", systemImage:"photo.circle.fill")
//                }
//                .font(.system(.headline, design: .rounded))
//                .tag(3)
            
            MainProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(2)
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
        
        //            .tabViewStyle(PageTabViewStyle())
        //TODO: change tab bar color
        }
    }
}


struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
