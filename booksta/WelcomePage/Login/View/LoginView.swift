//
//  LoginView.swift
//  booksta
//
//  Created by Catalina Besliu on 18.02.2022.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordHidden: Bool = true
    @State private var showingAlert = false
    @State private var moveToNextPage = false
    
    @Binding var ownIndex: Int
    @Binding var signUpIndex: Int
    
    @FocusState private var fieldIsFocused: Bool
    
    var body: some View {
        logInView
            .alert("Make sure that all fields are completed", isPresented: $showingAlert) {
                Button("OK", role: .none) { }
            }
    }
    
    private var logInTitle: some View {
        HStack {
            Text("Log In")
                .foregroundColor(self.ownIndex == 1 ? .white : .gray)
                .font(.title)
                .fontWeight(.bold)
            Spacer(minLength: 0)
        }
        .padding(.top, 40)//top curve
    }
    
    private var logInView: some View {
        VStack(spacing: 20) {
            logInTitle
            VStack {
                getEmailField(title: "Email address", stateText: $email)
                getFieldToBeCompleted(title: "Password", stateText: $password)
                forgetPasswordView
                NavigationLink(destination: ProfileView(), isActive: $moveToNextPage) { EmptyView() }
                Button(action: logIn, label: {
                    loginButtonView
                })
                .padding(.top, 20)
            }
            .opacity(self.ownIndex == 1 ? 1 : 0)
        }
        .padding()
        .padding(.bottom, 30)
        .background(Color.bookstaGrey500)
        .clipShape(CShapeLeftCurve())
        .contentShape(CShapeLeftCurve())
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
        .onTapGesture {
            self.ownIndex = 1
            self.signUpIndex = 0
            
        }
        .cornerRadius(35)
        .padding(.horizontal, 20)
    }
    
    private var loginButtonView: some View {
        Text("Log In")
            .foregroundColor(.bookstaGrey50)
            .padding(.vertical, 16)
            .padding(.horizontal, 40)
            .background(Color.bookstaPink)
            .clipShape(Capsule())
            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
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
    private var forgetPasswordView: some View {
        HStack {
            Spacer()
            Button(action: {
            }) {
                Text("Forget password?")
                    .foregroundColor(.bookstaGrey50)
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
        }
        .padding(.vertical, 10)
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
        //TODO: show an alert
        showingAlert = !viewModel.checkFieldsAreCompleted(email: email, password: password)
        moveToNextPage = !showingAlert
    }
}


//    struct LoginView_Previews: PreviewProvider {
//        static var previews: some View {
//            LoginView(, index: 0)
//        }
//    }

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
