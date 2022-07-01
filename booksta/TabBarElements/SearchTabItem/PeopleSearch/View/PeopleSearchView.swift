//
//  PeopleSearchView.swift
//  booksta
//
//  Created by Catalina Besliu on 02.03.2022.
//

import SwiftUI
import Resolver

struct PeopleSearchView: View {
    @ObservedObject var viewModel: PeopleSearchViewModel = Resolver.resolve()
    @Binding var ownIndex: Int
    @Binding var bookViewIndex: Int
    
    @State var curbeRadius: CGFloat
    @State var curbeHeight: CGFloat
    @State var showFiltersView = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                content
                    .onAppear(perform: {
                        viewModel.searchText = ""
                        viewModel.changeState()
                        viewModel.fetchFilters()
                    })
                if showFiltersView {
                    Color.bookstaPurple
                        .opacity(0.15)
                        .frame(maxHeight: .infinity)
                }
            }
            .clipped()
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.5)) {
                    showFiltersView = false
                }
            }
            
            if showFiltersView {
                FilterView(viewModel: viewModel)
                    .modalPresenter(title: "Filtering options", onDismiss: {
                        withAnimation(.easeIn(duration: 0.5)) {
                            showFiltersView = false
                        }
                    })
                    .transition(.bottomslide)
                    .frame(height: 150)
                    .zIndex(1)
            }
        }
    }
    
    private func getStateView(state: DataState<[UserModel]>) -> some View {
        switch state {
        case .idle, .loading :
            return VStack {
                Spacer()
                Text("Loading...")
                Spacer()
            }
            .eraseToAnyView()
        case let .loaded(users) :
            return UsersScrollView(users: users)
                .eraseToAnyView()
        case let.error(errorDescription) :
            return VStack {
                Spacer()
                Text("\(errorDescription)")
                Spacer()
            }
            .eraseToAnyView()
        }
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top){
                Spacer()
                Text("People search")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.bookstaPurple800)
                    .padding(.trailing, 15)
                    .padding(.top, 5)
                    .frame(height: curbeHeight, alignment: .top)
            }
            VStack(spacing: 10) {
                SearchBar(text: $viewModel.searchText, placeholder: "Search for somebody", button: AnyView(filterView))
                FilterHeader(viewModel: viewModel)
                getStateView(state: viewModel.state)
            }
        }
        .padding([.horizontal, .top])
        .background(Color.bookstaBackground)
        .clipShape(PeopleSearchShape(radius: curbeRadius, height: curbeHeight))
        .contentShape(PeopleSearchShape(radius: curbeRadius, height: curbeHeight))
        .onTapGesture {
            self.ownIndex = 1
            self.bookViewIndex = 0
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
        .cornerRadius(30)
    }
    
    private var filterView: some View {
        Button {
            UIApplication.shared.endEditing()
            withAnimation(.spring(response: 1, dampingFraction: 1, blendDuration: 0.2)) {
                showFiltersView.toggle()
            }
            
        } label: {
            Image(systemName: "line.3.horizontal.decrease")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.bookstaPurple)
        }
    }
}

