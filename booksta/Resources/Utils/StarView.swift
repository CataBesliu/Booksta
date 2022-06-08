//
//  StarView.swift
//  booksta
//
//  Created by Catalina Besliu on 07.06.2022.
//

import SwiftUI

struct StarView: View {
    @Binding var rating: Int
    var isActive = true
    var maxReviewRating = 5
    var fullColor = Color.bookstaPurple800
    
    var width: CGFloat = 35
    var height: CGFloat = 30
    
    var body: some View {
        HStack {
            ForEach(1..<maxReviewRating + 1, id: \.self) { number in
                image(for: number)
                    .onTapGesture {
                        if isActive {
                            rating = number
                        }
                    }
            }
        }
    }
    
    private var emptyImage: some View {
        Image(systemName: "book")
            .resizable()
            .frame(width: width, height: height)
            .foregroundColor(.bookstaPurple800)
    }
    private var fullImage: some View {
        Image(systemName: "book.fill")
            .resizable()
            .frame(width: width, height: height)
            .foregroundColor(.bookstaPurple800)
    }
    
    private func image(for number: Int) -> some View {
        if number > rating {
            return emptyImage
                .eraseToAnyView()
        } else {
            return fullImage
                .eraseToAnyView()
        }
    }
}

struct StarView_Previews: PreviewProvider {
    static var previews: some View {
        StarView(rating: .constant(4))
    }
}
