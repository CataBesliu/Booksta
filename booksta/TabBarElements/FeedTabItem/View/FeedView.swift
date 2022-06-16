//
//  FeedView.swift
//  booksta
//
//  Created by Catalina Besliu on 07.06.2022.
//

import SwiftUI
import Resolver

struct FeedView: View {
    
    @ObservedObject var profileViewModel: MainProfileViewModel = Resolver.resolve()
    @State var showSheet = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ZStack {
                    VStack {
                        bookstaLogo
                            .zIndex(1)
                        
                        VStack(spacing: 8) {
                            Divider()
                                .frame(height: 1)
                                .foregroundColor(.bookstaPurple800)
                            
                            content
                        }
                    }
                    .background(Color.white)
                    
                    if showSheet {
                        Color.bookstaPurple
                            .opacity(0.15)
                            .frame(maxHeight: .infinity)
                    }
                }
                .clipped()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 1)) {
                        showSheet = false
                    }
                }
                
                
                if showSheet {
                    addPostView
                        .transition(.bottomslide)
                        .zIndex(1)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    
    private var bookstaLogo: some View  {
        HStack {
            Image("iconLogo")
                .resizable()
                .frame(width: 100, height: 20)
            Spacer()
            Button {
                withAnimation(.spring(response: 1, dampingFraction: 1, blendDuration: 0.2)) {
                    showSheet.toggle()
                }
                
            } label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.bookstaPurple800)
            }
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 10)
    }
    
    private var content: some View {
        ScrollView {
            VStack {
                iconFeedView
                
                Text("Feed")
                    .foregroundColor(.bookstaPurple800)
                
                Spacer()
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .background(Color.white)
    }
    
    private var iconFeedView: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image("iconFeed")
                    .resizable()
                    .frame(width: 111, height: 96)
                
                if let user = profileViewModel.user {
                    Text("Welcome back, \(user.email)!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Text("Welcome back!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                Text("See what your freaders read lately")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.vertical, 20)
            
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.bookstaPurple400, .bookstaPurple]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing))
        .cornerRadius(4)
    }
    
    private var addPostView: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                VStack(alignment: .center, spacing: 8) {
                    Rectangle()
                        .frame(width: 80, height: 4)
                        .foregroundColor(.bookstaGrey500)
                        .cornerRadius(4)
                    Text("Create")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.bookstaPurple800)
                }
                Spacer()
            }
            Divider().frame(height: 1)
            NavigationLink(destination: AddPostView()) {
                addPostButtonView
            }
            
        }
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private var addPostButtonView: some View {
        HStack(spacing: 20) {
            Image(systemName: "plus.circle")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(.bookstaPurple800)
            Text("Add post")
                .font(.system(size: 15))
                .foregroundColor(.bookstaPurple800)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
}

extension AnyTransition {
    static var bottomslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .bottom))
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
