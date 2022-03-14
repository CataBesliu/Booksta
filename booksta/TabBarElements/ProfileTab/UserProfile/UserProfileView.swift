//
//  UserProfileView.swift
//  booksta
//
//  Created by Catalina Besliu on 08.03.2022.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    //    var user: UserModel
    //    @State var isFollowed: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .leading) {
                booksReadView
                ZStack(alignment: .trailing){
                    HStack{
                        Spacer()
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                        Spacer()
                    }
                    followingView
                }
            }
            Text("\(viewModel.user.email)")
            Button(action: {
                viewModel.isFollowedState ? viewModel.unfollowUser() : viewModel.followUser()
                viewModel.getIsUserFollowed()
            }, label: {
                followButton
            })
            
            Spacer()
        }
        .onAppear(perform: {
            viewModel.fetchUserData()
        })
    }
    
    var followButton: some View {
        var title: String
        if viewModel.isFollowedState {
            title = "Following"
        } else {
            title = "Follow"
        }
        return BookstaButton(title: title)
        
    }
    
    var booksReadView: some View {
        VStack {
            Text("Books read")
            switch viewModel.stateForProperties {
            case .idle, .loading:
                Text("...")
            case let .loaded(userProperties):
                Text("\(userProperties.booksRead)")
            case let .error(error):
                EmptyView()
            }
        }
        .padding(.leading, 20)
    }
    
    var followingView: some View {
        VStack {
            Text("Following")
            switch viewModel.stateForProperties {
            case .idle, .loading:
                Text("...")
            case let .loaded(userProperties):
                Text("\(userProperties.following)")
            case let .error(error):
                EmptyView()
            }
        }
        .padding(.trailing, 20)
    }
    
    func handleProfilePhotoSelect() {
        print("print")
    }
}

//struct UserProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfileView(user: UserModel(dictionary:))
//    }
//}
