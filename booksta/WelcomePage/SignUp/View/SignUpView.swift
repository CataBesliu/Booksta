//
//  SignUpView.swift
//  booksta
//
//  Created by Catalina Besliu on 20.02.2022.
//

import SwiftUI
import Resolver

struct SignUpView: View {
    @ObservedObject var profileViewModel : MainProfileViewModel = Resolver.resolve()
    @ObservedObject var viewModel = SignUpViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""
    @State private var showingAlertForPasswordsNotMacthing = false
    @State private var showingAlertForUncompletedFields = false
    @State private var isPasswordHidden: Bool = true
    
    @Binding var ownIndex: Int
    @Binding var logInIndex: Int
    
    @FocusState private var fieldIsFocused: Bool
    
    var body: some View {
        signUpView
            .alert("Make sure that all fields are completed", isPresented: $showingAlertForUncompletedFields) {
                Button("OK", role: .none) { }
            }
            .alert("Passwords do not match", isPresented: $showingAlertForPasswordsNotMacthing) {
                Button("OK", role: .none) { }
            }
    }
    
    private var signUpTitle: some View {
        HStack {
            Spacer(minLength: 0)
            Text("Sign Up")
                .foregroundColor(self.ownIndex == 1 ? .bookstaPurple800 : .bookstaPurple900)
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
                
                Button(action: checkFields, label: {
                    signUpButtonView
                })
                .padding(.top, 20)
            }
            .opacity(self.ownIndex == 1 ? 1 : 0)
        }
        .padding()
        .padding(.bottom, 30)
        .background(Color.bookstaGrey100)
        .clipShape(CShapeRightCurve())
        .contentShape(CShapeRightCurve())
//        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
        .onTapGesture {
            self.ownIndex = 1
            self.logInIndex = 0
        }
        .cornerRadius(35)
        .shadow(color: .bookstaPurple800, radius: 10)
        .padding(.horizontal, 20)
    }
    
    private var signUpButtonView: some View {
        BookstaButton(title: "Sign Up")
    }
    
    ///Function to call for email field
    private func getEmailField(title: String, stateText: Binding<String>) -> some View {
        return  VStack(alignment: .leading, spacing: 5)  {
            HStack(spacing: 5) {
                Image(systemName: "envelope")
                    .font(.system(size: 20))
                    .foregroundColor(.bookstaPurple800)
                ZStack(alignment: .leading) {
                    if stateText.wrappedValue.isEmpty {
                        placeholder(title)
                    }
                    TextField(title, text: stateText)
                        .focused($fieldIsFocused)
                        .foregroundColor(.bookstaPurple800)
                }
                
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
                    .foregroundColor(.bookstaPurple800)
                VStack {
                    if isPasswordHidden {
                        ZStack(alignment: .leading) {
                            if stateText.wrappedValue.isEmpty {
                                placeholder(title)
                            }
                            SecureField(title, text: stateText)
                                .foregroundColor(.bookstaPurple800)
                        }
                    } else {
                        ZStack(alignment: .leading) {
                            if stateText.wrappedValue.isEmpty {
                                placeholder(title)
                            }
                            TextField(title, text: stateText)
                                .foregroundColor(.bookstaPurple800)
                        }
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
                        .foregroundColor(.bookstaPurple800)
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
    private func placeholder(_ title: String) -> some View {
        Text(title)
            .foregroundColor(.bookstaPurple800)
    }
    
    private func checkFields() {
        fieldIsFocused = false
        showingAlertForUncompletedFields = !viewModel.checkFieldsAreCompleted(email: email, password1: password, password2: repeatedPassword)
        showingAlertForPasswordsNotMacthing = !viewModel.checkPasswordsMatch(password1: password, password2: repeatedPassword)
        if !(showingAlertForUncompletedFields || showingAlertForPasswordsNotMacthing) {
            signUp()
        }
    }
    
    private func signUp() {
        let credentials = SignUpModel(email: email, password: password, repeatedPassword: repeatedPassword)
        AuthService.registerUser(withCredential: credentials, completion: { error in
            if let error = error {
                print("DEBUG - Failed to register user \(error.localizedDescription) ")
                return
            }
            //TODO: check if an email was already registered
            print("DEBUG - Succesfully registered user with firestore...")
            profileViewModel.checkIfUserIsLoggedIn()
        })
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
