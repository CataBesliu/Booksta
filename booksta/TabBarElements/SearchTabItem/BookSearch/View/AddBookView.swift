//
//  AddBookView.swift
//  booksta
//
//  Created by Catalina Besliu on 29.03.2022.
//

import SwiftUI

struct AddBookView: View {
    @State private var bookName: String = ""
    @State private var publishYear: String = ""
    @State private var description: String = ""
    @State private var genre: BookGenre = .empty
    //TODO: add author functionality
    @State private var authorList: [Author] = []
    
    @State private var selection: BookGenre = .empty 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Name of the book:")
            TextField("...", text: $bookName)
                .foregroundColor(.bookstaGrey50)
            Text("Publish year:")
            TextField("...", text: $publishYear)
                .foregroundColor(.bookstaGrey50)
            Text("Description:")
            TextField("Description:", text: $description)
                .foregroundColor(.bookstaGrey50)
            Text("Book genre")
            genreView
            Spacer()
        }
        .padding()
        .navigationTitle("Add a book")
    }
    
    private var genreView: some View {
        Menu {
            Picker(selection: $selection) {
            Text(BookGenre.horror.rawValue).tag(BookGenre.horror)
            Text(BookGenre.comedy.rawValue).tag(BookGenre.comedy)
            Text(BookGenre.scify.rawValue).tag(BookGenre.scify)
            Text(BookGenre.romantic.rawValue).tag(BookGenre.romantic)
            } label: {}
        } label: {
            Text(selection == .empty ? "+" : selection.rawValue)
                .font(.system(size: 20))
                .padding(5)
                .background(Color.bookstaPink)
                .foregroundColor(.bookstaGrey50 )
                .cornerRadius(4)
            }
    }
    
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
