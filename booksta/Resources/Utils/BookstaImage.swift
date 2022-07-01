//
//  BookstaImage.swift
//  booksta
//
//  Created by Catalina Besliu on 08.06.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookstaImage: View {
    var url: String
    var height: CGFloat = 80
    var width: CGFloat = 70
    var placeholderImage: String?
    var isHeightGiven = true
    var isSystemPhoto = true
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.bookstaGrey100
                .frame(width: width, height: height)
            if let placeholderImage = placeholderImage {
                if isSystemPhoto {
                Image(systemName: placeholderImage)
                    .resizable()
                    .frame(width: width, height: height)
                    .foregroundColor(.bookstaPurple)
                } else {
                    Image(placeholderImage)
                        .resizable()
                        .frame(width: width, height: height)
                        .foregroundColor(.bookstaPurple)
                }
            }
            if URL.isValid(urlString: url) {
                if isHeightGiven {
                WebImage(url: URL(string: url))
                    .resizable()
                    .frame(width: width, height: height)
                } else {
                    WebImage(url: URL(string: url))
                        .resizable()
                        .scaledToFill()
                }
            }
        }
        
    }
}
