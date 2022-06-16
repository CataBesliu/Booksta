//
//  View+Extension.swift
//  booksta
//
//  Created by Catalina Besliu on 23.02.2022.
//

import SwiftUI
import UIKit

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
