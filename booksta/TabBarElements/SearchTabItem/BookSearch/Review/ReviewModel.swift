//
//  ReviewModel.swift
//  booksta
//
//  Created by Catalina Besliu on 07.06.2022.
//

import Foundation

struct ReviewModel: Hashable, Equatable {
    let id: String
    let reviewGrade: Int
    let reviewDescription: String
    let timestamp: Date?
    
    init(dictionary: [String: Any], id: String?) {
        self.id = id ?? ""
        self.reviewGrade = dictionary["reviewGrade"] as? Int ?? 0
        self.reviewDescription = dictionary["reviewDescription"] as? String ?? ""
        self.timestamp = ReviewModel.getDate(data: dictionary["timestamp"] as? String ?? "")
    }
    
    static func getDate(data: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        if let date = dateFormatter.date(from: data) {
            return date
        } else {
            return nil
        }
    }
}

struct ReviewerModel: Equatable, Hashable {
    let user: UserModel
    let review: ReviewModel
    
    init(user: UserModel, review: ReviewModel) {
        self.user = user
        self.review = review
    }
    
}
//            let calendar = Calendar.autoupdatingCurrent
//            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//            let components = calendar.dateComponents(in: TimeZone.current, from: date)
