//
//  SearchBar.swift
//  booksta
//
//  Created by Catalina Besliu on 06.03.2022.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    @FocusState private var fieldIsFocused: Bool
    var placeholder: String
    var textDisplayed = ""
    
    var body: some View {
        HStack {
            HStack(spacing: 5) {
                Image(systemName: "magnifyingglass.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.bookstaPink)
                    .padding(.vertical, 5)
                
                TextField(isEditing && fieldIsFocused ? "\(text)" : "\(placeholder)...", text: $text)
                    .focused($fieldIsFocused)
                .padding(5)
                .foregroundColor(isEditing ? .white : .gray)
                
                Spacer()
                if isEditing && self.text != "" {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.white)
                            .padding(.trailing, 8)
                    }
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color(.systemGray6))
            .cornerRadius(15)
            
            if isEditing && fieldIsFocused {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                //                .transition(.move(edge: .trailing))
                .animation(.easeInOut(duration: 2000), value: isEditing)
            }
        }
        .onTapGesture {
            self.isEditing = true
            self.text = ""
        }
        //TODO: animatioon
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""), placeholder: "Search for a book")
    }
}
