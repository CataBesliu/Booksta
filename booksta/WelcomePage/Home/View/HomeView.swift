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
        NavigationView {
            VStack(spacing: 10) {
                Spacer()
                Image("iconLogo")
                    .resizable()
                    .frame(width: 140, height: 28)
                Spacer()
                ZStack(alignment: .center) {
                    LoginView(ownIndex: self.$indexForLoginPage, signUpIndex: self.$indexForSignUpPage)
                        .zIndex(Double(self.indexForLoginPage))
                    
                    SignUpView(ownIndex: self.$indexForSignUpPage, logInIndex: self.$indexForLoginPage)
                        .zIndex(Double(self.indexForSignUpPage))
                }
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.all)
            .background(Color.bookstaPurple200)
            .preferredColorScheme(.light)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
