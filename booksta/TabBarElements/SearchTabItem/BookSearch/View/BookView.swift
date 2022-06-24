//
//  BookView.swift
//  booksta
//
//  Created by Catalina Besliu on 29.03.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookView: View {
    @ObservedObject var reviewViewModel: AddBookReviewViewModel
    @State var showAddReview = false
    
    var imageWidth: CGFloat = 70
    
    init(book: BookModel) {
        self.reviewViewModel = AddBookReviewViewModel(book: book)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                BookHeaderView(book: reviewViewModel.book, imageWidth: imageWidth)
                VStack(spacing: 20) {
                    genreScrollView
                    Divider()
                        .frame(height: 2)
                    VStack(spacing: 30) {
                        Toggle(isOn: $reviewViewModel.isRead) {
                            HStack {
                                Text("Have you read this book?")
                                    .font(.system(size: 15))
                                    .foregroundColor(.bookstaPurple800)
                                Spacer()
                            }
                        }
                        .foregroundColor(.bookstaPurple)
                        if reviewViewModel.isRead {
                            addReviewButton
                        }
                        descriptionView
                        reviewContent
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .background(Color.white)
        .navigationTitle("")
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            reviewViewModel.hasUserSentReviewFunction()
            reviewViewModel.getReviews()
            reviewViewModel.hasUserReadBook()
        }
    }
    
    private var genreScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0 ..< reviewViewModel.book.genres.count) {index in
                    BookstaButton(title: "\(reviewViewModel.book.genres[index])",
                                  bgColor: Color.bookstaGrey100,
                                  paddingV: 7,
                                  paddingH: 20,
                                  titleSize: 12,
                                  titleColor: .bookstaPurple800,
                                  titleWeight: .bold)
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
                          titleWeight: .bold,
                          isMaxWidth: true)
        }
    }
    
    private var descriptionView: some View {
        VStack(spacing: 18) {
            HStack {
                Text("Description")
                    .foregroundColor(.bookstaPurple800)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            Text("\(reviewViewModel.book.description)")
                .foregroundColor(.bookstaPurple800)
                .font(.system(size: 15))
        }
    }
    
    private var reviewContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Reviews")
                .foregroundColor(.bookstaPurple800)
                .font(.system(size: 20, weight: .bold))
                .leadingStyle()
            switch reviewViewModel.state {
            case .idle:
                Text("No reviews available")
                    .foregroundColor(.bookstaPurple800)
                    .font(.system(size: 15))
                    .leadingStyle()
            case .loading:
                Text("Loading reviews...")
                    .foregroundColor(.bookstaPurple800)
                    .font(.system(size: 15))
                    .leadingStyle()
            case .error:
                Text("An error occured")
                    .foregroundColor(.red)
                    .font(.system(size: 15))
                    .leadingStyle()
                
            case .loaded(let reviewers):
                VStack(spacing: 10) {
                    ForEach(reviewers, id: \.self) { reviewer in
                        reviewCell(reviewerModel: reviewer)
                    }
                }
                .animation(.default, value: reviewViewModel.state)
            }
        }
    }
    
    private func reviewCell(reviewerModel: ReviewerModel) -> some View{
        VStack(spacing: 5) {
            HStack(spacing: 10) {
                BookstaImage(url: reviewerModel.user.imageURL,
                             height: 34,
                             width: 34,
                             placeholderImage: "person.crop.circle")
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                
                VStack {
                    Text(reviewerModel.user.email)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.bookstaPurple800)
                }
                Spacer()
            }
            VStack(spacing: 8) {
                Divider()
                    .frame(height: 2)
                VStack(alignment: .leading, spacing: 5) {
                    Text(reviewerModel.review.reviewDescription)
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(.bookstaPurple800)
                        .leadingStyle()
                    StarView(rating: .constant(reviewerModel.review.reviewGrade), isActive: false, width: 20, height: 15)
                        .padding(.leading, 3)
                    
                }
            }
        }
        .padding()
        .background(Color.bookstaPurple.opacity(0.3))
        .cornerRadius(10)
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
            
            BookstaImage(url: book.thumbnail, placeholderImage: "iconBookBackground")
                .clipShape(Rectangle())
                .border(.white, width: 3)
                .cornerRadius(4)
                .offset(x: 16, y: 40)
                .shadow(color: Color.bookstaPurple800, radius: 5)
            
            HStack {
                Text("\(book.name)")
                    .font(.system(size: 18, weight: .bold))
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
