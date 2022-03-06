//
//  TabBarView.swift
//  booksta
//
//  Created by Catalina Besliu on 25.02.2022.
//

import SwiftUI
import Firebase

struct TabBarView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            Text("Feed")
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
            SecondAttempt()
                .tabItem {
                    Label("Review", systemImage: "book.closed.circle")
                }
                .font(.system(.headline, design: .rounded))
                .tag(2)
            
            Text("Add post")
                .tabItem {
                    Label("Post", systemImage:"photo.circle.fill")
                }
                .font(.system(.headline, design: .rounded))
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(4)
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = .darkGray
            UITabBar.appearance().barTintColor = .white
        }
        .accentColor(.bookstaPink)
        .background(Color.bookstaGrey500)
        .frame(
            width: UIScreen.main.bounds.width ,
            height: UIScreen.main.bounds.height
        )
        .edgesIgnoringSafeArea(.all)
        
        //            .tabViewStyle(PageTabViewStyle())
        //TODO: change tab bar color
    }
}


struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
