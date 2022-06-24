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
        } else {
            VStack {
                Text("Loading...")
                    .font(.system(size: 18))
                    .foregroundColor(.bookstaPurple800)
                    .centerStyle()
                Spacer()
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

struct UsersScrollView: View {
    @State var users: [UserModel]?
    
    var body: some View {
        if let users = users {
            ScrollView {
                ForEach(users, id: \.self) { user in
                    NavigationLink(destination: UserProfileView(viewModel: UserProfileViewModel(user: user))) {
                        getUserCell(user: user)
                    }
                }
            }
        } else {
            VStack {
                Text("Loading...")
                    .font(.system(size: 18))
                    .foregroundColor(.bookstaPurple800)
                    .centerStyle()
                Spacer()
            }
        }
    }
    
    private func getUserCell(user: UserModel) -> some View {
        HStack(spacing: 20) {
            BookstaImage(url: user.imageURL,
                         height: 60,
                         width: 60,
                         placeholderImage: "person.crop.circle")
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            
            Text("@\(user.username)")
                .font(.system(size: 20,weight: .bold))
                .foregroundColor(Color.bookstaPurple800)
            Spacer()
        }
        .padding(10)
        .overlay(
            Rectangle()
                .stroke(Color.bookstaPurple800, lineWidth: 1)
        )
    }
}

struct PostsScrollView: View {
    @State var users: [UserModel]?
    
    var body: some View {
        if let users = users {
            ScrollView {
                ForEach(users, id: \.self) { user in
                    NavigationLink(destination: UserProfileView(viewModel: UserProfileViewModel(user: user))) {
                        getUserCell(user: user)
                    }
                }
            }
        } else {
            VStack {
                Text("Loading...")
                    .font(.system(size: 18))
                    .foregroundColor(.bookstaPurple800)
                    .centerStyle()
                Spacer()
            }
        }
    }
    
    private func getUserCell(user: UserModel) -> some View {
        HStack(spacing: 20) {
            BookstaImage(url: user.imageURL,
                         height: 60,
                         width: 60,
                         placeholderImage: "person.crop.circle")
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            
            Text("@\(user.username)")
                .font(.system(size: 20,weight: .bold))
                .foregroundColor(Color.bookstaPurple800)
            Spacer()
        }
        .padding(10)
        .overlay(
            Rectangle()
                .stroke(Color.bookstaPurple800, lineWidth: 1)
        )
    }
}

struct GenreView: View {
    @State var wasDismissed = false
    var title: String
    var onDismiss: () -> Void
    
    var body: some View {
        HStack {
            if !wasDismissed {
                HStack(spacing: 3) {
                    Text("\(title)")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.bookstaPurple800)
                    Button {
                        withAnimation(.linear) {
                            wasDismissed = true
                            onDismiss()
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.bookstaPurple800)
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 6)
                .background(Color.bookstaPurple800.opacity(0.3))
                .cornerRadius(8)
            } else {
                EmptyView()
            }
        }
    }
}


struct GenreHeader: View {
    var genres: [String]
    
    var body: some View {
        HStack(alignment: .center) {
            if genres.count > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(genres, id: \.self) { genre in
                            GenreView(title: "\(genre)") {
                                print("closed")
                            }
                        }
                    }
                }
            }
            Button {
                //TODO: add genre posibility
                print("Add genre")
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.bookstaPurple)
            }
        }
    }
}
