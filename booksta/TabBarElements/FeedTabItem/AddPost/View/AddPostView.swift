//
//  AddPostView.swift
//  booksta
//
//  Created by Catalina Besliu on 17.06.2022.
//

import SwiftUI

struct AddPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddPostViewModel
    
    @State var postDescription: String = ""
    @State private var showingAlert = false
    @State private var showBooks = true
    
    @State var postImage: UIImage?
    @State private var isLibrarySheetPresented = false
    
    init() {
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().tintColor = UIColor(named: "bookstaPurple800")
        self.viewModel = AddPostViewModel()
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 20) {
                        getPhotoView(width: geometry.size.width)
                        
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
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.bookstaPurple800, lineWidth: 2))
                                .frame(height: 150)
                        }
                        bookReadingView
                        if let book = viewModel.selectedBook,
                           !postDescription.isEmpty {
                            withAnimation(.easeIn(duration: 2)) {
                                Button {
                                    viewModel.sendPost(postDescription: postDescription)
                                    //TODO: add completion
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    BookstaButton(title: "Send post", paddingV: 10, titleSize: 15, titleWeight: .bold, isMaxWidth: true)
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .clipped()
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .padding()
        }
        //        .navigationTitle("")
        //        .edgesIgnoringSafeArea(.top)
        .bookstaNavigationBar(title: "Add new post",
                              showBackBtn: true,
                              onBackButton: {
            self.presentationMode.wrappedValue.dismiss()
        })
        .onChange(of: postImage, perform: { newImage in
            viewModel.resetImageState()
            viewModel.uploadPhoto(image: newImage)
        })
        .sheet(isPresented: $isLibrarySheetPresented) {
            ImagePicker(selectedImage: $postImage)
        }
    }
    
    private func getPhotoView(width: CGFloat) -> some View {
        Button {
            isLibrarySheetPresented = true
        } label: {
            ZStack(alignment: .center) {
                if !viewModel.imageURL.isEmpty {
                    BookstaImage(url: viewModel.imageURL,
                                 isHeightGiven: false)
                    .frame(width: width)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.bookstaPurple, lineWidth: 3))
                    .zIndex(1)
                }
                Rectangle()
                    .frame(width: width, height: width)
                    .foregroundColor(Color.bookstaPurple)
                    .cornerRadius(10)
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var bookReadingView: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Reading")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.bookstaPurple800)
                Spacer()
            }
            VStack(spacing: 0) {
                SimpleSearchBar(text: $viewModel.searchText, placeholder: "What are you reading?")
                
                if viewModel.listOfBooks.count > 0,
                   !viewModel.searchText.isEmpty,
                   viewModel.showBooks {
                    
                    ForEach(viewModel.listOfBooks, id: \.self) { book in
                        HStack {
                            Spacer()
                                .frame(width: 10)
                            HStack {
                                Text(book.name)
                                    .foregroundColor(.bookstaPurple800)
                                    .font(.system(size: 15))
                                Spacer()
                            }
                            .padding(7)
                            .background(Color.bookstaPurple.opacity(0.2))
                            .border(Color.bookstaPurple800, width: 1)
                            
                            Spacer()
                                .frame(width: 40)
                        }
                        .clipped()
                        .onTapGesture {
                            viewModel.searchText = book.name
                            viewModel.selectBook(book: book)
                        }
                    }
                }
            }
        }
    }
    
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}
