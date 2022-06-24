//
//  EditProfileView.swift
//  booksta
//
//  Created by Catalina Besliu on 20.06.2022.
//

import SwiftUI
import Resolver


struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: MainProfileViewModel = Resolver.resolve()
    @State private var isLibrarySheetPresented = false
    @State private var profileImage: UIImage?
    
    init(){
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        VStack {
            title
            profileContent
            Spacer()
        }
        .bookstaNavigationBar(onBackButton: {
            self.presentationMode.wrappedValue.dismiss()},
                              showBackBtn: true,
                              onOkButton: saveFunction)
        .onChange(of: profileImage, perform: { newImage in
            viewModel.resetImageState()
            viewModel.uploadPhoto(image: newImage)
            viewModel.getUserInformation()
        })
        .sheet(isPresented: $isLibrarySheetPresented) {
            ImagePicker(selectedImage: $profileImage)
        }
    }
    
    private var profileContent: some View {
        Text("bla")
    }
    
    private func getProfileHeaderView(mainUser: UserModel?) -> some View {
        VStack(spacing: 20) {
            HStack(spacing: 13){
                Button(action: {
                    isLibrarySheetPresented = true
                }) {
                    profileImageView
                }
                Text("@\(viewModel.user?.username ?? "-")")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.bookstaPurple800)
                    .padding(.bottom, 10)
                Spacer()
            }
        }
        .padding(.top)
        .padding(.horizontal, 20)
    }
    
    private var profileImageView(): some View {
        return VStack {
            switch viewModel.imageState {
            case .idle,.loading:
                Text("Loading...")
                    .foregroundColor(.bookstaPurple800)
                    .frame(width: 70, height: 70, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.bookstaPurple800, lineWidth: 2))
            case let .loaded(imageURL):
                BookstaImage(url: imageURL,
                             height: 70,
                             width: 70,
                             placeholderImage: "person.crop.circle")
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                
            case let .error(_):
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 70, height: 70, alignment: .center)
                    .foregroundColor(.bookstaPurple800)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.bookstaPurple800, lineWidth: 2))
            }
        }
    }
    
    private func saveFunction() {
        print("ok")
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
