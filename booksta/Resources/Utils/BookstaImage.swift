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
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.bookstaGrey100
                .frame(width: width, height: height)
            if let placeholderImage = placeholderImage {
                Image(systemName: placeholderImage)
                    .resizable()
                    .frame(width: width, height: height)
                    .foregroundColor(.bookstaPurple)
            }
            if URL.isValid(urlString: url) {
                WebImage(url: URL(string: url))
                    .resizable()
                    .frame(width: width, height: height)
            }
        }
        
    }
}
