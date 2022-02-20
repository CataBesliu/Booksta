//
//  SignUpView.swift
//  booksta
//
//  Created by Catalina Besliu on 20.02.2022.
//

import SwiftUI

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var repeatedPassword: String = ""
    
    @State private var isPasswordHidden: Bool = true
    @Binding var ownIndex: Int
    @Binding var logInIndex: Int
    
    @FocusState private var fieldIsFocused: Bool
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            signUpView
        }
    }
    
    private var signUpTitle: some View {
        HStack {
            Spacer(minLength: 0)
            Text("SignUp")
                .foregroundColor(.white)
                .font(.title)
                .fontWeight(.bold)
        }
        .padding(.top, 40)//top curve
    }
    
    private var signUpView: some View {
        VStack(spacing: 20) {
            signUpTitle
            VStack {
                getEmailField(title: "Email address", stateText: $email)
                getFieldToBeCompleted(title: "Password", stateText: $password)
                getFieldToBeCompleted(title: "Repeat password", stateText: $repeatedPassword)
                
                Button(action: signIn) {
                    Text("Sign In")
                        .foregroundColor(.bookstaGrey50)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 40)
                        .background(Color.bookstaPink)
                        .clipShape(Capsule())
                        .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
                }
            }
            .opacity(self.ownIndex == 1 ? 1 : 0)
            
        }
        .padding()
        .padding(.bottom, 65)
        .background(Color.bookstaGrey500)
        .clipShape(CShapeRightCurve())
        .contentShape(CShapeRightCurve())
        .onTapGesture {
            self.ownIndex = 1
            self.logInIndex = 0
        }
        .cornerRadius(35)
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
    
    private func signIn() {
        fieldIsFocused = false
        //viewModel.logInFunction(email: email, password: password)
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
