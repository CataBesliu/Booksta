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
    
    @State var curbeRadius: CGFloat
    @State var curbeHeight: CGFloat
    
    @State var searchText = ""
    var listOfBooks = ["A"]
    
    
    var body: some View {
        VStack(spacing: 0) {
                HStack(alignment: .top){
                    Text("Book search")
                        .font(.system(size: 15, weight: .bold))
                        .padding(.leading, 15)
                        .padding(.top, 5)
                        .frame(height: curbeHeight, alignment: .top)
                    Spacer()
                }
                SearchBar(text: $searchText, placeholder: "Search for a book")
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
            .clipShape(BookSearchShape(radius: curbeRadius, height: curbeHeight))
            .contentShape(BookSearchShape(radius: curbeRadius, height: curbeHeight))
            .onTapGesture {
                self.ownIndex = 1
                self.peopleViewIndex = 0
                //TODO: keyboard dismiss
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .cornerRadius(30)
    }
}

//struct BookSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookSearchView()
//    }
//}
