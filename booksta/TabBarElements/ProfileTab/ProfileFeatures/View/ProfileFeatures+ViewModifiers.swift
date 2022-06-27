//
//  ProfileFeatures+ViewModifiers.swift
//  booksta
//
//  Created by Catalina Besliu on 21.06.2022.
//

import SwiftUI

struct ModalPresenter: ViewModifier {
    var title: String
    var onDismiss: () -> Void
    
    func body(content: Content) -> some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 1)
                .frame(width: 30, height: 1)
                .background(Color.bookstaPurple800)
                .foregroundColor(.bookstaPurple800)
            HStack {
                Spacer()
                Text("\(title)")
                    .foregroundColor(.bookstaPurple800)
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
            }
            Divider()
                .frame(height: 1)
                .foregroundColor(.bookstaPurple)
            content
                .background(Color.bookstaGrey50)
            Spacer()
        }
        .padding(.top, 5)
        .background(Color.bookstaGrey50)
        .simultaneousGesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.height > 25 {
                        onDismiss()
                    }
                }
        )
        .clipped()
        .shadow(color: .bookstaGrey500, radius: 5)
    }
}

extension View {
    func modalPresenter(title: String, onDismiss: @escaping () -> Void) -> some View {
        modifier(ModalPresenter(title: title, onDismiss: onDismiss))
    }
}


struct BookstaNavigationBar: ViewModifier {
    var showBackBtn: Bool = false
    var onBackButton: () -> Void
    var title = ""
    var okButtonImg = ""
    var onOkButton: (() -> Void)?
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            CustomDivider()
            content
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if title.isEmpty {
                    bookstaLogo
                    
                } else {
                    Text("\(title)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.bookstaPurple800)
                }
            }
        }
        .navigationBarItems(leading: btnBack)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                btnOk
            }
        }
    }
    
    private var bookstaLogo: some View  {
        VStack {
            HStack {
                Image("iconLogo")
                    .resizable()
                    .frame(width: 100, height: 20)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            .zIndex(1)
        }
    }
    
    private var btnBack : some View {
        if showBackBtn {
            return Button(action: {
                self.onBackButton()
            }) {
                HStack {
                    Image(systemName: "arrow.backward.square")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .foregroundColor(.bookstaPurple)
                .leadingStyle()
            }
            .eraseToAnyView()
        } else {
            return EmptyView()
                .eraseToAnyView()
        }
    }
    
    private var btnOk : some View {
        if let okFunction = onOkButton {
            return Button(action: {
                okFunction()
            }) {
                HStack {
                    Image(systemName: "\(okButtonImg)")
                        .resizable()
                        .frame(width: 30, height: 26)
                }
                .foregroundColor(.bookstaPurple)
            }
            .eraseToAnyView()
        } else {
            return EmptyView()
                .eraseToAnyView()
        }
    }
}


extension View {
    func  bookstaNavigationBar(title: String = "",
                               showBackBtn: Bool = false,
                               onBackButton: @escaping () -> Void,
                               okButtonImg: String = "person.crop.circle.badge.checkmark",
                               onOkButton: (() -> Void)? = nil) -> some View {
        modifier(BookstaNavigationBar(showBackBtn: showBackBtn,
                                      onBackButton: onBackButton,
                                      title: title,
                                      okButtonImg: okButtonImg,
                                      onOkButton: onOkButton))
    }
}
