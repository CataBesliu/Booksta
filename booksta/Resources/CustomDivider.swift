//
//  CustomDivider.swift
//  booksta
//
//  Created by Catalina Besliu on 18.02.2022.
//

import SwiftUI

struct CustomDivider: View {
    var color: Color = .bookstaGrey200
    var width: CGFloat = 1
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct CustomDivider_Previews: PreviewProvider {
    static var previews: some View {
        CustomDivider()
    }
}
