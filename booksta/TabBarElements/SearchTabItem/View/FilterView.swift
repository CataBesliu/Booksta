//
//  FilterView.swift
//  booksta
//
//  Created by Catalina Besliu on 30.06.2022.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: GeneralSearchViewModel
    @State var showAuthors = false
    
    var body: some View {
        VStack {
            NavigationLink(destination: GenreSearchView(viewModel: viewModel)) {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass.circle")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.bookstaPurple)
                    Text("Search by genres")
                        .foregroundColor(.bookstaPurple)
                        .font(.system(size: 17, weight: .semibold))
                    Spacer()
                }
                .padding(.horizontal)
            }
            if showAuthors {
                Divider()
                NavigationLink(destination: AuthorsSearchView(viewModel: viewModel)) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass.circle")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.bookstaPurple)
                        Text("Search by authors")
                            .foregroundColor(.bookstaPurple)
                            .font(.system(size: 17, weight: .semibold))
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            if viewModel.selectedGenres.count > 0 || viewModel.selectedAuthors.count > 0 {
                Button {
                    viewModel.selectedGenres = []
                    viewModel.selectedAuthors = []
                    viewModel.resetState()
                    viewModel.changeState()
                } label: {
                    BookstaButton(title: "Delete filters", paddingV: 5)
                }
            }
            
        }
        .foregroundColor(.bookstaPurple)
    }
    
    private func onOkButton() {
        //        viewModel.updateProfileGenres(selectedGenres: selectedGenres)
        self.presentationMode.wrappedValue.dismiss()
        
    }
}



struct GenreSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: GeneralSearchViewModel
    @State var selectedGenres: [String] = []
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $viewModel.genreSearchText, placeholder: "Type in genre...")
                .padding()
            Divider()
            ScrollView {
                VStack(spacing: 1) {
                    ForEach(viewModel.displayedGenres, id: \.self) { genre in
                        GenreFilterCell(selectedGenres: $selectedGenres, title: genre)
                    }
                }
            }
            .background(Color.bookstaGrey200.opacity(0.5))
        }
        .bookstaNavigationBar(title: "Search genres",
                              showBackBtn: true,
                              onBackButton: { self.presentationMode.wrappedValue.dismiss() },
                              onOkButton: onOkButton)
    }
    
    private func onOkButton() {
        viewModel.updateSearchGenres(genres: selectedGenres)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct GenreFilterCell: View {
    @Binding var selectedGenres: [String]
    
    @State var wasSelected: Bool = false
    
    var title: String
    
    var body: some View {
        HStack {
            Text("\(title)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.bookstaPurple800)
            Spacer()
            if wasSelected {
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.bookstaPurple)
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 20)
        .background(.white)
        .clipped()
        .onTapGesture {
            withAnimation(.linear) {
                wasSelected.toggle()
            }
            var tempArray: [String] = []
            if wasSelected {
                selectedGenres.append(title)
            } else {
                for genre in selectedGenres {
                    if genre != title {
                        tempArray.append(genre)
                    }
                }
                selectedGenres = tempArray
            }
        }
    }
}



struct AuthorsSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: GeneralSearchViewModel
    @State var selectedAuthors: [String] = []
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $viewModel.authorSearchText, placeholder: "Type in author...")
                .padding()
            Divider()
            ScrollView {
                VStack(spacing: 1) {
                    ForEach(viewModel.displayedAuthors, id: \.self) { author in
                        AuthorFilterCell(selectedAuthors: $selectedAuthors, title: author)
                    }
                }
            }
            .background(Color.bookstaGrey200.opacity(0.5))
        }
        .bookstaNavigationBar(title: "Search authors",
                              showBackBtn: true,
                              onBackButton: { self.presentationMode.wrappedValue.dismiss() },
                              onOkButton: onOkButton)
    }
    
    private func onOkButton() {
        viewModel.updateSearchAuthors(authors: selectedAuthors)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AuthorFilterCell: View {
    @Binding var selectedAuthors: [String]
    
    @State var wasSelected: Bool = false
    
    var title: String
    
    var body: some View {
        HStack {
            Text("\(title)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.bookstaPurple800)
            Spacer()
            if wasSelected {
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.bookstaPurple)
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 20)
        .background(.white)
        .clipped()
        .onTapGesture {
            withAnimation(.linear) {
                wasSelected.toggle()
            }
            var tempArray: [String] = []
            if wasSelected {
                selectedAuthors.append(title)
            } else {
                for author in selectedAuthors {
                    if author != title {
                        tempArray.append(author)
                    }
                }
                selectedAuthors = tempArray
            }
        }
    }
}

struct FilterHeader: View {
    @ObservedObject var viewModel: GeneralSearchViewModel
    
    var body: some View {
        if viewModel.selectedAuthors.count > 0 || viewModel.selectedGenres.count > 0 {
            HStack(spacing: 5) {
                Text("Filters:")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.bookstaPurple800)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(Array(viewModel.selectedAuthors.enumerated()), id: \.offset) { index, element in
                            FilterCellView(title: "\(element)")
                        }
                        ForEach(Array(viewModel.selectedGenres.enumerated()), id: \.offset) { index, element in
                            FilterCellView(title: "\(element)")
                        }
                    }
                }
            }
        }
    }
}

struct FilterCellView: View {
    var title: String
    
    var body: some View {
        HStack {
            Text("\(title)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.bookstaPurple800)
        }
        .padding(.vertical, 7)
        .padding(.horizontal)
        .background(Color.bookstaPurple200)
        .cornerRadius(15)
    }
}
