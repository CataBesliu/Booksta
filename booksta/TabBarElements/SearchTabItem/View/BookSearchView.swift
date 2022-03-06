//
//  BookSearchView.swift
//  booksta
//
//  Created by Catalina Besliu on 02.03.2022.
//

import SwiftUI

struct BookSearchView: View {
    
    @Binding var ownIndex: Int
    @Binding var peopleViewIndex: Int
    
    @State var searchText = ""
    var listOfBooks = ["A","Ba","C","DE","E","F","G"]
    
    
    var body: some View {
            VStack {
                HStack(alignment: .top){
                    Text("Book search")
                        .padding(5)
                    Spacer()
                    //                Spacer()
                }
                SearchBar(text: $searchText)
                ScrollView {
                    ForEach(listOfBooks.filter({ searchText.isEmpty ? true : $0.contains(searchText) }), id: \.self) { item in
                        Text(item)
                    }
                }
                Spacer()
                
            }
            .padding()
            .padding(.bottom, 30)
            .background(Color.bookstaBackground)
            .clipShape(BookSearchShape())
            .contentShape(BookSearchShape())
            .onTapGesture {
                self.ownIndex = 1
                self.peopleViewIndex = 0
            }
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .cornerRadius(20)
    }
}

//struct BookSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookSearchView()
//    }
//}
