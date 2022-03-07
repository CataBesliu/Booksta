//
//  SearchShapes.swift
//  booksta
//
//  Created by Catalina Besliu on 02.03.2022.
//

import SwiftUI

struct BookSearchShape : Shape {
    let radius: CGFloat
    let height: CGFloat
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width/2 - radius, y: 0))
            path.addQuadCurve(to: CGPoint(x: rect.width/2, y: height/2), control: CGPoint(x: rect.width/2 , y: 0))
            path.addQuadCurve(to: CGPoint(x: rect.width/2 + radius, y: height), control: CGPoint(x: rect.width/2 + 10, y: height))
            path.addLine(to: CGPoint(x: rect.width, y: height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}


struct PeopleSearchShape : Shape {
    let radius: CGFloat
    let height: CGFloat
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width/2 + radius, y: 0))
            path.addQuadCurve(to: CGPoint(x: rect.width/2, y: height/2), control: CGPoint(x: rect.width/2 , y: 0))
            path.addQuadCurve(to: CGPoint(x: rect.width/2 - radius, y: height), control: CGPoint(x: rect.width/2 - 10, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}
