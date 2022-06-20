//
//  ProfileFeatures.swift
//  booksta
//
//  Created by Catalina Besliu on 19.06.2022.
//

import SwiftUI

struct BooksScrollView: View {
    @State var books: [BookModel]?
    
    var body: some View {
        if let books = books {
            ScrollView {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: BookView(book: book)) {
                        getBookCell(book: book)
                    }
                }
            }
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
struct ReviewScrollView: View {
    @State var reviews: [ReviewModel]?
    
    var body: some View {
        if let reviews = reviews {
            ScrollView {
                ForEach(reviews, id: \.self) { review in
                        getReviewCell(review: review)
                    }
                }
            }
    }
    
    private func getReviewCell(review: ReviewModel) -> some View {
        HStack(spacing: 20) {
            Text("\(review.reviewDescription)")
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

struct ModalPresenter: ViewModifier {
    var title: String
    var onDismiss: () -> Void
    
    func body(content: Content) -> some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 1)
                .frame(width: 30, height: 1)
                .background(Color.bookstaPurple800)
                .foregroundColor(.bookstaPurple800)
            HStack {
                Spacer()
                Text("\(title)")
                    .foregroundColor(.bookstaPurple800)
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
            }
            Divider()
                .frame(height: 1)
                .foregroundColor(.bookstaPurple)
            content
                .background(Color.bookstaGrey50)
            Spacer()
        }
        .padding(.top, 5)
        .background(Color.bookstaGrey50)
        .simultaneousGesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.height > 10 {
                        onDismiss()
                    }
                }
        )
        .clipped()
        .shadow(color: .bookstaGrey500, radius: 5)
    }
}

extension View {
    func modalPresenter(title: String, onDismiss: @escaping () -> Void) -> some View {
        modifier(ModalPresenter(title: title, onDismiss: onDismiss))
    }
}
