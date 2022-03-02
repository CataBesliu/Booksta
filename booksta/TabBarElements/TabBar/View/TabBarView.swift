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
        NavigationView {
            TabView(selection: $selection) {
                Text("Feed")
                .tabItem {
                    Label("Home", systemImage: "house.circle.fill")
                }
                .font(.system(.headline, design: .rounded))
                .tag(0)
                
                Text("Review books")
                    .tabItem {
                        Label("Review", systemImage: "book.closed.circle")
                    }
                    .font(.system(.headline, design: .rounded))
                    .tag(1)
                Text("Add post")
                    .tabItem {
                        Label("Post", systemImage:"photo.circle.fill")
                    }
                    .font(.system(.headline, design: .rounded))
                    .tag(2)
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle.fill")
                    }
                    .tag(3)
            }
            .onAppear() {
                UITabBar.appearance().backgroundColor = .darkGray
                UITabBar.appearance().barTintColor = .white
            }
            .accentColor(.bookstaPink)
            .background(Color.bookstaGrey500)
            //TODO: change tab bar color
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
