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
    
    var body: some View {
        HStack {
            HStack(spacing: 5) {
                Image(systemName: "magnifyingglass.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.bookstaPurple800)
                    .padding(.vertical, 5)
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        placeholder("\(placeholder)...")
                    }
                    TextField(text, text: $text)
                        .foregroundColor(.bookstaPurple800)
                        .focused($fieldIsFocused)
                        .padding(5)
                }
                
                Spacer()
                if isEditing && self.text != "" {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.bookstaPurple800)
                            .padding(.trailing, 8)
                    }
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color.bookstaGrey100)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.bookstaPurple800, lineWidth: 2)
            )
            
            if isEditing && fieldIsFocused {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }) {
                    Text("Cancel")
                        .foregroundColor(.bookstaPurple800)
                }
                .padding(.trailing, 10)
                //                .transition(.move(edge: .trailing))
                .animation(.easeInOut(duration: 2000), value: isEditing)
            }
        }
        .onTapGesture {
            self.isEditing = true
            //            self.text = ""
        }
    }
    
    private func placeholder(_ title: String) -> some View {
        Text(title)
            .foregroundColor(.bookstaPurple800)
            .padding(.leading, 6)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""), placeholder: "Search for a book")
    }
}
