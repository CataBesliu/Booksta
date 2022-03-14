//
//  BookstaButton.swift
//  booksta
//
//  Created by Catalina Besliu on 09.03.2022.
//

import SwiftUI

struct BookstaButton: View {
    var title: String
    
    var body: some View {
        Text("\(title)")
            .foregroundColor(.bookstaGrey50)
            .padding(.vertical, 16)
            .padding(.horizontal, 40)
            .background(Color.bookstaPink)
            .clipShape(Capsule())
            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct BookstaButton_Previews: PreviewProvider {
    static var previews: some View {
        BookstaButton(title: "Log out")
    }
}
