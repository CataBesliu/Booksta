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
    @State private var isPasswordHidden: Bool = true
    
    
    @FocusState private var fieldIsFocused: Bool
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        GeometryReader{_ in
            VStack {
                //TODO: logo image
                Image(systemName: "books.vertical.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.bookstaPink)
                logInView
                
            }
            Spacer()
        }
        .background(Color.bookstaBackground)
//        .edgesIgnoringSafeArea(.all)
        .preferredColorScheme(.dark)
    }
    
    private var logInTitle: some View {
        HStack {
            Text("Login")
                .foregroundColor(.white)
                .font(.title)
                .fontWeight(.bold)
            Spacer(minLength: 0)
        }
        .padding(.top, 40)//top curve
    }
    
    private var logInView: some View {
        VStack(spacing: 20) {
            logInTitle
            getEmailField(title: "Email address", stateText: $email)
            getFieldToBeCompleted(title: "Password", stateText: $password)
            
            Button(action: logIn) {
                Text("Sign In")
                    .foregroundColor(.bookstaGrey50)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 40)
                    .background(Color.bookstaPink)
                    .cornerRadius(20)
            }
            
        }
        .padding(30)
        .background(Color.bookstaGrey500)
        .padding(.horizontal, 20)
    }
    
    ///Function to call for email field
    private func getEmailField(title: String, stateText: Binding<String>) -> some View {
        return  VStack(alignment: .leading, spacing: 5)  {
            HStack(spacing: 5) {
                Image(systemName: "envelope")
                    .font(.system(size: 20))
                    .foregroundColor(.bookstaPink)
                
                TextField(title, text: stateText)
                    .focused($fieldIsFocused)
                    .foregroundColor(.bookstaGrey50)
                
                Spacer()
            }
            .padding(10)
            .onSubmit {
                //do some validation
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .foregroundColor(.bookstaGrey200)
            .cornerRadius(4)
            
            CustomDivider()
        }
    }
    
    ///Function to call for password field
    private func getFieldToBeCompleted(title: String, stateText: Binding<String>) -> some View {
        return  VStack(alignment: .leading, spacing: 5)  {
            HStack(spacing: 5) {
                Image(systemName: "lock")
                    .font(.system(size: 20))
                    .foregroundColor(.bookstaPink)
                VStack {
                    if isPasswordHidden {
                        SecureField(title, text: stateText)
                    } else {
                        TextField(title, text: stateText)
                    }
                }
                .focused($fieldIsFocused)
                .foregroundColor(.bookstaGrey50)
                Spacer()
                Button(action: {
                    isPasswordHidden.toggle()
                }) {
                    Image(systemName: self.isPasswordHidden ? "eye.slash" : "eye")
                        .font(.system(size: 16))
                        .foregroundColor(.bookstaPink)
                }
            }
            .padding(10)
            .onSubmit {
                //do some validation
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .foregroundColor(.bookstaGrey200)
            .cornerRadius(4)
            
            CustomDivider()
        }
    }
    
    private func logIn() {
        fieldIsFocused = false
        viewModel.logInFunction(email: email, password: password)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
