//
//  FeedView.swift
//  booksta
//
//  Created by Catalina Besliu on 07.06.2022.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Feed")
                .foregroundColor(.bookstaPurple800)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
