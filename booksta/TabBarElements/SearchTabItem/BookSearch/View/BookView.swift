//
//  BookView.swift
//  booksta
//
//  Created by Catalina Besliu on 29.03.2022.
//

import SwiftUI

struct BookView: View {
    var book: BookModel
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ZStack(alignment: .bottomLeading) {
                        Image("iconBookBackground")
                            .resizable()
                            .frame(height: 150)
                            .frame(maxWidth: .infinity)
                        Image("iconBookBackground")
                            .resizable()
                            .frame(width: 60, height: 80)
                            .clipShape(Rectangle())
                            .offset(x: 16, y: 40)
                        Text("book name")
                            .font(Font.custom("Poppins-Italic", size: 18))
                            .padding(.bottom, 10)
                            .offset(x: 92, y: 0)
                        
                    }
                    VStack {
                        Spacer()
                    }
                    .background(Color.white)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(book: BookModel(dictionary: ["name": "Padurea Spanzuratilor",
                                              "authors": ["Liviu Rebreanu"]]))
    }
}
