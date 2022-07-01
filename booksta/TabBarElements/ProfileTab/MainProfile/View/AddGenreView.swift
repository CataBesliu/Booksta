//
//  AddGenreView.swift
//  booksta
//
//  Created by Catalina Besliu on 25.06.2022.
//

import SwiftUI

struct AddGenreView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: EditProfileViewModel
    @State var selectedGenres: [String] = []
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $viewModel.genreSearchText, placeholder: "Type in genre...")
                .padding()
            Divider()
            ScrollView {
                VStack(spacing: 1) {
                    ForEach(viewModel.availableGenres, id: \.self) { genre in
                        GenreCell(selectedGenres: $selectedGenres, title: genre)
                    }
                }
            }
            .background(Color.bookstaGrey200.opacity(0.5))
        }
        .onAppear( perform: viewModel.getAllGenres )
        .bookstaNavigationBar(title: "Add new genres",
                              showBackBtn: true,
                              onBackButton: { self.presentationMode.wrappedValue.dismiss() },
                              onOkButton: onOkButton)
    }
    
    private func onOkButton() {
        viewModel.updateProfileGenres(selectedGenres: selectedGenres)
        self.presentationMode.wrappedValue.dismiss()
    }
}


struct GenreCell: View {
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
