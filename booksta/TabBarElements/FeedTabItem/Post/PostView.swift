//
//  PostView.swift
//  booksta
//
//  Created by Catalina Besliu on 17.06.2022.
//

import SwiftUI

struct PostView: View {
    @ObservedObject var viewModel: PostViewModel
    var userPostModel: UserPostModel
    var dateFormatter: DateFormatter
    
    init(userPostModel: UserPostModel) {
        self.userPostModel = userPostModel
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        self.viewModel = PostViewModel()
    }
    
    var body: some View {
        postCell(user: userPostModel.user, post: userPostModel.post)
            .onAppear{
            viewModel.getBook(bookID: userPostModel.post.bookID)
            }
    }
    
    private func postCell(user: UserModel, post: PostModel) -> some View{
        VStack(spacing: 5) {
            HStack(spacing: 10) {
                BookstaImage(url: user.imageURL,
                             height: 34,
                             width: 34,
                             placeholderImage: "person.crop.circle")
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                VStack(spacing: 3) {
                    Text(user.username)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.bookstaPurple800)
                    if let timestamp = post.timestamp{
                        Text( self.dateFormatter.string(from: timestamp))
                            .font(.system(size: 13))
                            .foregroundColor(.bookstaPurple800)
                    }
                }
                Spacer()
            }
            VStack(spacing: 8) {
                Divider()
                    .frame(height: 2)
                Text(post.description)
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(.bookstaPurple800)
                    .leadingStyle()
                VStack(spacing: 20) {
                    //TODO: post image
                    HStack(spacing: 5) {
                        Image(systemName: "eye")
                            .resizable()
                            .frame(width: 20, height: 14)
                            .foregroundColor(.bookstaPurple)
                        Text("reads")
                            .font(.system(size: 14))
                            .foregroundColor(.bookstaPurple800)
                        if let book = viewModel.book {
                            NavigationLink {
                                BookView(book: book)
                            } label: {
                                Text("\(post.bookName)")
                                    .font(.system(size: 14))
                                    .foregroundColor(.bookstaPurple)
                            }
                        } else {
                            Text("\(post.bookName)")
                                .font(.system(size: 14))
                                .foregroundColor(.bookstaPurple)
                        }
                    }
                    .leadingStyle()
                }
            }
        }
        .padding()
        .border(Color.bookstaPurple, width: 3)
        .cornerRadius(10)
    }
}

//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostView()
//    }
//}
