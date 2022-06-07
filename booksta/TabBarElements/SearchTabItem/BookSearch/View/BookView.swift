//
//  BookView.swift
//  booksta
//
//  Created by Catalina Besliu on 29.03.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookView: View {
    @State var showAddReview = false
    
    var book: BookModel
    @ObservedObject var reviewViewModel: AddBookReviewViewModel
    var imageWidth: CGFloat = 70
    
    init(book: BookModel) {
        self.book = book
        self.reviewViewModel = AddBookReviewViewModel(book: book)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                BookHeaderView(book: book, imageWidth: imageWidth)
                VStack(spacing: 20) {
                    genreScrollView
                    Divider()
                        .frame(height: 2)
                    VStack(spacing: 30) {
                        addReviewButton
                        descriptionView
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .background(Color.white)
        .navigationTitle("")
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            reviewViewModel.hasUserSentReviewFunction(bookID: "\(book.id)")
        }
    }
    
    private var genreScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0 ..< book.genres.count) {index in
                    BookstaButton(title: "\(book.genres[index])",
                                  bgColor: Color.bookstaGrey100,
                                  paddingV: 7,
                                  paddingH: 20,
                                  titleSize: 12,
                                  titleColor: .bookstaPurple800)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 10)
        }
    }
    
    private var addReviewButton: some View {
        NavigationLink(destination: AddReviewView(viewModel: reviewViewModel)) {
            BookstaButton(title: reviewViewModel.hasUserSentReview ? "Edit review" : "Add review",
                          bgColor: .bookstaPurple,
                          paddingV: 12,
                          paddingH: 120,
                          titleSize: 17,
                          titleColor: .bookstaGrey50,
                          titleWeight: .bold)
        }
    }
    
    private var descriptionView: some View {
        VStack(spacing: 18) {
            HStack {
                Text("Description")
                    .foregroundColor(.bookstaPurple800)
                    .font(.system(size: 20))
                Spacer()
            }
            Text("\(book.description)")
                .foregroundColor(.bookstaPurple800)
                .font(.system(size: 13))
        }
    }
    
    private func addReview() {
        showAddReview = true
    }
}

struct BookHeaderView: View {
    var book: BookModel
    var imageWidth: CGFloat = 70
    
    var body: some View {
        VStack {
            headerView
            authorsView
                .offset(x: imageWidth + 32, y: 0)
        }
    }
    
    private var headerView: some View {
        ZStack(alignment: .bottomLeading) {
            Image("iconBookBackground")
                .resizable()
                .frame(height: 150)
                .frame(maxWidth: .infinity)
            
            Image("iconBookBackground")
                .resizable()
                .frame(width: imageWidth, height: 80)
                .clipShape(Rectangle())
                .border(.white, width: 3)
                .cornerRadius(4)
                .offset(x: 16, y: 40)
                .shadow(color: Color.bookstaPurple800, radius: 5)
            
            if URL.isValid(urlString: book.thumbnail) {
                WebImage(url: URL(string: book.thumbnail))
                    .resizable()
                    .frame(width: imageWidth, height: 80)
                    .clipShape(Rectangle())
                    .border(.white, width: 3)
                    .cornerRadius(4)
                    .offset(x: 16, y: 40)
                    .shadow(color: Color.bookstaPurple800, radius: 5)
            }
            
            HStack {
                Text("\(book.name)")
                    .font(.system(size: 18))
                    .lineLimit(1)
                    .padding(.trailing, 92)
                    .padding(.bottom, 10)
                Spacer()
            }
            .zIndex(1)
            .offset(x: imageWidth + 32, y: 0)
            
        }
    }
    
    private var authorsView: some View {
        VStack {
            ForEach(0 ..< book.authors.count) {index in
                HStack {
                    Text("\(book.authors[index])")
                        .font(.system(size: 14))
                        .foregroundColor(.bookstaGrey500)
                    Spacer()
                }
            }
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(book: BookModel(dictionary: ["name": "Padurea Spanzuratilor",
                                              "authors": ["Liviu Rebreanu",
                                                          "Liviu Rebreanu"],
                                              "categories":["Fiction",
                                                            "Drama",
                                                            "Romantic",
                                                            "Comedy",
                                                            "SciFy"],
                                              "description":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Non gravida ut mi laoreet. Nec egestas tellus proin ultrices morbi urna lobortis. Eget tellus pellentesque augue convallis at viverra vitae vulputate amet. Vitae faucibus iaculis massa in."], id: ""))
    }
}
