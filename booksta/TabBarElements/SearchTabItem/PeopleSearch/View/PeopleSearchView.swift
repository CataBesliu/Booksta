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
    
    //@State var searchText: String = ""
    
    var body: some View {
        content
            .onAppear(perform: {
                viewModel.searchText = ""
                viewModel.fetchUsers(searchTerm: viewModel.searchText)
            })
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
                
                SearchBar(text: $viewModel.searchText, placeholder: "Start looking for somebody")
                getStateView(state: viewModel.state)
            }
            Spacer()
            
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
}

//struct PeopleSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeopleSearchView(ownIndex: <#Binding<Int>#>, bookViewIndex: <#Binding<Int>#>)
//    }
//}
