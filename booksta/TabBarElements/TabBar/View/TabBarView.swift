//
//  TabBarView.swift
//  booksta
//
//  Created by Catalina Besliu on 25.02.2022.
//

import SwiftUI
import Firebase

struct TabBarView: View {
    @State private var isUserLoggedOut = false
    @Environment(\.presentationMode) var presentationMode
    let strings = ["1","2","3","4","5","6","7","8","5","3","2","1","4","56","7"]
    
    @State private var selection = 0
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                
                List(strings, id: \.self) { string in
                    NavigationLink(destination: Text("\(string)")) {
                        Text("\(string)")
                    }
                }
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
    
    private var logOutButtonView: some View {
        Text("Log out")
            .foregroundColor(.bookstaGrey50)
            .padding(.vertical, 16)
            .padding(.horizontal, 40)
            .background(Color.bookstaPink)
            .clipShape(Capsule())
            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            isUserLoggedOut = true
            self.presentationMode.wrappedValue.dismiss()
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
}


struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
