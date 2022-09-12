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
    @State var showFiltersView = false
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                content
                    .onAppear(perform: {
                        viewModel.searchText = ""
                        viewModel.changeState()
                        viewModel.fetchFilters()
                    })
                
                if showFiltersView {
                    Color.bookstaPurple
                        .opacity(0.15)
                        .frame(maxHeight: .infinity)
                }
                
            }
            .clipped()
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.5)) {
                    showFiltersView = false
                }
            }
            if showFiltersView {
                FilterView(viewModel: viewModel, showAuthors: true)
                    .modalPresenter(title: "Filtering options", onDismiss: {
                        withAnimation(.easeIn(duration: 0.5)) {
                            showFiltersView = false
                        }
                    })
                    .transition(.bottomslide)
                    .frame(height: 170)
                    .zIndex(1)
            }
        }
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
                SearchBar(text: $viewModel.searchText, placeholder: "Search for a book", button: AnyView(filterView))
                FilterHeader(viewModel: viewModel)
                getStateView(state: viewModel.state)
            }
            
        }
        .padding([.horizontal, .vertical])
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
    
    private var filterView: some View {
        Button {
            withAnimation(.spring(response: 1, dampingFraction: 1, blendDuration: 0.2)) {
                showFiltersView.toggle()
            }
            
        } label: {
            Image(systemName: "line.3.horizontal.decrease")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.bookstaPurple)
        }
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
            return  ScrollView {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: BookView(book: book)) {
                        getBookCell(book: book)
                    }
                }
            }
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
            BookstaImage(url: book.thumbnail,
                         height: 50,
                         width: 50,
                         placeholderImage: "book.circle")
            .clipShape(Circle())
            .overlay(Circle().stroke(lineWidth: 2))
            Text("\(book.name)")
                .font(.system(size: 20,weight: .bold))
                .foregroundColor(.bookstaPurple800)
            Spacer()
        }
        .padding()
        .overlay(
            Rectangle()
                .stroke(Color.bookstaPurple800, lineWidth: 1)
        )
    }
}

