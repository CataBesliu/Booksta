//
//  ReviewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 07.06.2022.
//

import Foundation

struct ReviewModel: Hashable {
    let id: String
    let reviewGrade: Int
    let reviewDescription: String
//    let timestamp: String
    
    init(dictionary: [String: Any], id: String?) {
        self.id = id ?? ""
        self.reviewGrade = dictionary["reviewGrade"] as? Int ?? 0
        self.reviewDescription = dictionary["reviewDescription"] as? String ?? ""
        
//        self.timestamp = dictionary["timestamp"].toDate().toDateString() as? String ?? ""
    }
}
