//
//  URL+Extension.swift
//  booksta
//
//  Created by Catalina Besliu on 07.06.2022.
//

import SwiftUI

extension URL {
    static func isValid (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
