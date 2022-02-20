//
//  HomeView.swift
//  booksta
//
//  Created by Catalina Besliu on 20.02.2022.
//

import SwiftUI

struct HomeView: View {
    @State var indexForLoginPage = 1
    @State var indexForSignUpPage = 0
    
    var body: some View {
        GeometryReader{_ in
            VStack {
                //TODO: logo image
                Image(systemName: "books.vertical.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.bookstaPink)
                    .padding(.top, 100)
                
                ZStack {
                    LoginView(ownIndex: self.$indexForLoginPage, signUpIndex: self.$indexForSignUpPage)
                        .zIndex(Double(self.indexForLoginPage))
                    
                    SignUpView(ownIndex: self.$indexForSignUpPage, logInIndex: self.$indexForLoginPage)
                        .zIndex(Double(self.indexForSignUpPage))
                }
            }
        }
        .background(Color.bookstaBackground)
        .preferredColorScheme(.dark)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
