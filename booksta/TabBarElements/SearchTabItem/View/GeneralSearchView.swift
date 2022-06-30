//
//  GeneralSearchView.swift
//  booksta
//
//  Created by Catalina Besliu on 03.03.2022.
//

import SwiftUI

struct GeneralSearchView: View {
    @State var indexForBookSearch = 1
    @State var indexForPeopleSearch = 0
    var body: some View {
        NavigationView {
            ZStack {
                Color.bookstaPurple.opacity(0.1)
                Color.white
                    .padding(.top,50)
                
                ZStack {
                    BookSearchView(ownIndex: self.$indexForBookSearch, peopleViewIndex: self.$indexForPeopleSearch, curbeRadius: 30, curbeHeight: 50)
                        .zIndex(Double(self.indexForBookSearch))
                    
                    PeopleSearchView(ownIndex: self.$indexForPeopleSearch, bookViewIndex: self.$indexForBookSearch, curbeRadius: 30, curbeHeight: 50)
                        .zIndex(Double(self.indexForPeopleSearch))
                }
                .padding(.top, 1)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .transition(.move(edge: .bottom))
        }
        .transition(.move(edge: .bottom))
    }
}

struct GeneralSearchView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSearchView()
    }
}
