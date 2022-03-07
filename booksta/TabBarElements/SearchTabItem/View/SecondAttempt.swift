//
//  SecondAttempt.swift
//  booksta
//
//  Created by Catalina Besliu on 03.03.2022.
//

import SwiftUI

struct SecondAttempt: View {
    
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            Text("Books")
                .tabItem {
                    Label("Home", systemImage: "house.circle.fill")
                }
                .font(.system(.headline, design: .rounded))
                .tag(0)
            
            
            Text("People")
                .frame(maxWidth: .infinity)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass.circle.fill")
                }
                .font(.system(.headline, design: .rounded))
            
                .tag(1)
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = .systemPink
            UITabBar.appearance().barTintColor = .white
        }
        .accentColor(.bookstaPink)
        .background(Color.bookstaGrey500)
//        .frame(
//            width: UIScreen.main.bounds.width ,
//            height: UIScreen.main.bounds.height
//        )
        .tabViewStyle(PageTabViewStyle())
    }
}
struct SecondAttempt_Previews: PreviewProvider {
    static var previews: some View {
        SecondAttempt()
    }
}
