//
//  BookSearchView.swift
//  booksta
//
//  Created by Catalina Besliu on 02.03.2022.
//

import SwiftUI
import Resolver

struct BookSearchView: View {
    @ObservedObject var viewModel: BookSearchViewModel = Resolver.resolve()
    @Binding var ownIndex: Int
    @Binding var peopleViewIndex: Int
    
    @State var curbeRadius: CGFloat
    @State var curbeHeight: CGFloat
    
    var body: some View {
        content
            .onAppear(perform: {
                viewModel.searchText = ""
                viewModel.fetchBooks(searchTerm: viewModel.searchText)
            })
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top){
                Text("Book search")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.bookstaPurple800)
                    .padding(.leading, 15)
                    .padding(.top, 5)
                    .frame(height: curbeHeight, alignment: .top)
                Spacer()
            }
            VStack(spacing: 10) {
                SearchBar(text: $viewModel.searchText, placeholder: "Search for a book")
                getStateView(state: viewModel.state)
            }
            
        }
        .padding([.horizontal, .top])
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
    
    private func getStateView(state: DataState<[BookModel]>) -> some View {
        switch state {
        case .idle, .loading :
            return VStack {
                Spacer()
                Text("Loading...")
                Spacer()
            }
            .eraseToAnyView()
        case let .loaded(books) :
            return ScrollView {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: BookView(book: book)) {
                        getBookCell(book: book)
                    }
                }
            }
            .animation(.default, value: viewModel.state)
            .eraseToAnyView()
        case let.error(errorDescription) :
            return VStack {
                Spacer()
                Text("\(errorDescription)")
                Spacer()
            }
            .eraseToAnyView()
        }
    }
    
    private func getBookCell(book: BookModel) -> some View {
        HStack(spacing: 20) {
            //            AsyncImage(url: URL(string: book.thumbnail)) { image in
            //                image.resizable()
            //            } placeholder: {
            //                Image(systemName: "book.circle")
            //                    .resizable()
            //            }
            Image(systemName: "book.circle")
                .resizable()
                .foregroundColor(.bookstaPurple800)
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            Text("\(book.name)")
                .font(.system(size: 20,weight: .bold))
                .foregroundColor(.bookstaPurple800)
            Spacer()
        }
        .padding()
        .background(Color.bookstaGrey100)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.bookstaPurple800, lineWidth: 1)
        )
        .padding(.vertical, 4)
    }
}

