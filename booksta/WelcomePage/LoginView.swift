//
//  LoginView.swift
//  booksta
//
//  Created by Catalina Besliu on 18.02.2022.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    //    @FocusState private var emailFieldIsFocused: Bool
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        GeometryReader{_ in
            VStack {
                //TODO: logo image
                logInView
                
            }
            Spacer()
        }
        .background(Color.bookstaBackground)
        .edgesIgnoringSafeArea(.all)
    }
    
    private var logInView: some View {
        VStack(spacing: 20) {
            //
            //            Text(email)
            //                .foregroundColor(emailFieldIsFocused ? .red : .blue)
            getFieldToBeCompleted(title: "Email Address", stateText: $email)
            getFieldToBeCompleted(title: "Password", stateText: $password)
            
            Button(action: logIn) {
                Text("Sign In")
                    .foregroundColor(.bookstaGrey50)
                    .padding(16)
                    .background(Color.bookstaPink)
                    .cornerRadius(4)
            }
            
            Spacer()
        }
        .background(Color.bookstaGrey800)
        .padding(30)
    }
    
    ///Function to call for email, password fields
    private func getFieldToBeCompleted(title: String, stateText: Binding<String>) -> some View {
        return  VStack(alignment: .leading, spacing: 5)  {
            SecureField(title, text: stateText)
            .padding(10)
            .onSubmit {
                //do some validation
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .foregroundColor(.bookstaGrey500)
            .cornerRadius(4)
        }
    }
    
    private func logIn() {
        viewModel.logInFunction(email: email, password: password)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
