//
//  BookstaButton.swift
//  booksta
//
//  Created by Catalina Besliu on 09.03.2022.
//

import SwiftUI

struct BookstaButton: View {
    var title: String
    var bgColor: Color = Color.bookstaPurple
    var paddingV: CGFloat = 16
    var paddingH: CGFloat = 40
    var titleSize: CGFloat = 20
    var titleColor: Color = Color.bookstaGrey50
    var titleWeight: Font.Weight = .regular
    var isMaxWidth = false
    
    var body: some View {
        Text("\(title)")
            .font(.system(size: titleSize, weight: titleWeight))
            .foregroundColor(titleColor)
            .padding(.vertical, paddingV)
            .padding(.horizontal, paddingH)
            .frame(maxWidth: isMaxWidth ? .infinity : nil)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct BookstaButton_Previews: PreviewProvider {
    static var previews: some View {
        BookstaButton(title: "Log out")
    }
}
