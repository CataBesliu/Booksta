//
//  AddPostView.swift
//  booksta
//
//  Created by Catalina Besliu on 17.06.2022.
//

import SwiftUI

struct AddPostView: View {
    @State var postDescription: String = ""
    @State private var showingAlert = false
    
    init() {
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().tintColor = UIColor(named: "bookstaPurple800")

    }
    
    var body: some View {
        VStack {
            addPhotoView
            
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    HStack {
                        Text("Description")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.bookstaPurple800)
                        Spacer()
                    }
                    TextEditor(text: $postDescription)
                        .foregroundColor(.bookstaPurple800)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color.bookstaPurple800, lineWidth: 1))
                        .frame(height: 150)
                }
                
                VStack(spacing: 10) {
                    HStack {
                        Text("Reading")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.bookstaPurple800)
                        Spacer()
                    }
                    
                }
            }
            Spacer()
        }
        .padding()
        .background(.white)
        .navigationTitle("")
        .navigationBarHidden(true)
        .clipped()
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    //    private var header: some View  {
    //        HStack {
    //            Spacer()
    //            Text("Add new post")
    //                .font(.system(size: 20, weight: .bold))
    //                .foregroundColor(.bookstaPurple800)
    //            Spacer()
    //        }
    //        .padding([.horizontal, .top])
    //        .padding(.bottom, 10)
    //    }
    
    private var addPhotoView: some View {
        Button {
            addPhoto()
        } label: {
            ZStack(alignment: .center) {
                Rectangle()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.bookstaPurple)
                    .cornerRadius(10)
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
        }
    }
    
    private func addPhoto() {
        
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}
