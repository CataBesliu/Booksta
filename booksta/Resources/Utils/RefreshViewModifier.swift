//
//  RefreshViewModifier.swift
//  booksta
//
//  Created by Catalina Besliu on 04.07.2022.
//

import Foundation

//
//struct ModalPresenter: ViewModifier {
//    var title: String
//    var onDismiss: () -> Void
//    
//    func body(content: Content) -> some View {
//        VStack(spacing: 10) {
//            RoundedRectangle(cornerRadius: 1)
//                .frame(width: 30, height: 1)
//                .background(Color.bookstaPurple800)
//                .foregroundColor(.bookstaPurple800)
//            HStack {
//                Spacer()
//                Text("\(title)")
//                    .foregroundColor(.bookstaPurple800)
//                    .font(.system(size: 20, weight: .semibold))
//                Spacer()
//            }
//            Divider()
//                .frame(height: 1)
//                .foregroundColor(.bookstaPurple)
//            content
//                .background(Color.bookstaGrey50)
//            Spacer()
//        }
//        .padding(.top, 5)
//        .background(Color.bookstaGrey50)
//        .simultaneousGesture(
//            DragGesture()
//                .onChanged { gesture in
//                    if gesture.translation.height > 25 {
//                        onDismiss()
//                    }
//                }
//        )
//        .clipped()
//        .shadow(color: .bookstaGrey500, radius: 5)
//    }
//}
//
//extension View {
//    func modalPresenter(title: String, onDismiss: @escaping () -> Void) -> some View {
//        modifier(ModalPresenter(title: title, onDismiss: onDismiss))
//    }
//}
