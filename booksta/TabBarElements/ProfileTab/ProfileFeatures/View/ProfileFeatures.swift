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


struct BookstaNavigationBar: ViewModifier {
    var showBackBtn: Bool = false
    var onBackButton: () -> Void
    
    func body(content: Content) -> some View {
        VStack {
            Divider()
                .frame(height: 1)
                .foregroundColor(.bookstaPurple800)
            content
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                bookstaLogo
            }
        }
        .navigationBarItems(leading: btnBack)
    }
    
    private var bookstaLogo: some View  {
        VStack {
            HStack {
                Image("iconLogo")
                    .resizable()
                    .frame(width: 100, height: 20)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            .zIndex(1)
        }
    }
    
    private var btnBack : some View {
        if showBackBtn {
            return Button(action: {
                self.onBackButton()
            }) {
                HStack {
                    Image(systemName: "arrow.backward.square")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .foregroundColor(.bookstaPurple)
                .leadingStyle()
            }
            .eraseToAnyView()
        } else {
            return EmptyView()
                .eraseToAnyView()
        }
    }
}


extension View {
    func bookstaNavigationBar(onBackButton: @escaping () -> Void, showBackBtn: Bool = false) -> some View {
        modifier(BookstaNavigationBar(showBackBtn: showBackBtn, onBackButton: onBackButton))
    }
}
