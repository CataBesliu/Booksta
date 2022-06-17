//
//  AddReviewView.swift
//  booksta
//
//  Created by Catalina Besliu on 07.06.2022.
//

import SwiftUI

struct AddReviewView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: AddBookReviewViewModel
    @State var bookReview: Int
    @State var bookReviewDescription: String
    @State private var showingAlert = false
    
    
    init(viewModel: AddBookReviewViewModel) {
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().tintColor = UIColor(named: "bookstaPurple800")


        self.viewModel = viewModel
        _bookReview = State(initialValue: viewModel.bookReview?.reviewGrade ?? 0 )
        _bookReviewDescription = State(initialValue: viewModel.bookReview?.reviewDescription ?? "")
    }
    
    var body: some View {
        ScrollView {
        VStack(spacing: 30) {
            VStack(spacing: 30) {
            BookHeaderView(book: viewModel.book)
                Divider()
                    .frame(height: 2)
            }
            VStack(spacing: 20) {
                rateView
                reviewCommentView
                
                Button {
                    showingAlert = !viewModel.checkFieldsAreCompleted(reviewGrade: bookReviewDescription)
                    if !showingAlert {
                    viewModel.sendReview(reviewGrade: bookReview, reviewDescription: bookReviewDescription)
                    presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    BookstaButton(title: viewModel.hasUserSentReview ? "Edit review" : "Send review",
                                  bgColor: .bookstaPurple,
                                  paddingV: 12,
                                  paddingH: 50,
                                  titleSize: 17,
                                  titleColor: .bookstaGrey50,
                                  titleWeight: .bold)
                }
            }
            .padding()
            Spacer(minLength: 2)
        }
        }
        .navigationTitle("")
        .edgesIgnoringSafeArea(.top)
        .background(Color.white)
        .alert("Make sure that all fields are completed",
               isPresented: $showingAlert) {
            Button("OK", role: .none) { }
        }
    }
    
    private var rateView: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                VStack(alignment: .center, spacing: 15) {
                    Text("How would you rate me?")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.bookstaPurple800)
                    StarView(rating: $bookReview)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .clipped()
        .shadow(color: .bookstaPurple800, radius: 2)
    }
    
    private var reviewCommentView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("How did I make you feel?")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.bookstaPurple800)
            TextEditor(text: $bookReviewDescription)
                .foregroundColor(.bookstaPurple800)
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.bookstaPurple800, lineWidth: 1))
                .frame(height: 150)
            
        }
        .padding()
        .background(Color.white)
        .clipped()
        .shadow(color: .bookstaPurple800, radius: 2)
    }
}

struct AddReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AddReviewView(viewModel: AddBookReviewViewModel(book: BookModel(dictionary: ["name": "Padurea Spanzuratilor",
                                                                                     "authors": ["Liviu Rebreanu",
                                                                                                 "Liviu Rebreanu"],
                                                                                     "categories":["Fiction",
                                                                                                   "Drama",
                                                                                                   "Romantic",
                                                                                                   "Comedy",
                                                                                                   "SciFy"],
                                                                                     "description":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Non gravida ut mi laoreet. Nec egestas tellus proin ultrices morbi urna lobortis. Eget tellus pellentesque augue convallis at viverra vitae vulputate amet. Vitae faucibus iaculis massa in."], id: "id")))
    }
}
