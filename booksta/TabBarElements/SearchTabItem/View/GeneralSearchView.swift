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
        ZStack {
            BookSearchView(ownIndex: self.$indexForBookSearch, peopleViewIndex: self.$indexForPeopleSearch)
                .zIndex(Double(self.indexForBookSearch))
            
            PeopleSearchView(ownIndex: self.$indexForPeopleSearch, bookViewIndex: self.$indexForBookSearch)
                .zIndex(Double(self.indexForPeopleSearch))
        }
    }
}

struct GeneralSearchView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSearchView()
    }
}
