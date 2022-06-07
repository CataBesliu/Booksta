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
            VStack {
                Spacer()
                //TODO: logo image
                Image(systemName: "book.closed.circle")
                    .font(.system(size: 80))
                    .foregroundColor(.bookstaPurple800)
                
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
            .background(Color.white)
            .preferredColorScheme(.dark)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
