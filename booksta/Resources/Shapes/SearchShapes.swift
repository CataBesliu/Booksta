//
//  SearchShapes.swift
//  booksta
//
//  Created by Catalina Besliu on 02.03.2022.
//

import SwiftUI

struct BookSearchShape : Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width/2-25, y: 0))
            path.addLine(to: CGPoint(x: rect.width/2-25, y: 10))
            path.addLine(to: CGPoint(x: rect.width/2-15, y: 10))
            path.addLine(to: CGPoint(x: rect.width/2-15, y: 20))
            path.addLine(to: CGPoint(x: rect.width/2-5, y: 20))
            path.addLine(to: CGPoint(x: rect.width/2-5, y: 30))
            path.addLine(to: CGPoint(x: rect.width/2+5, y: 30))
            path.addLine(to: CGPoint(x: rect.width/2+5, y: 40))
            path.addLine(to: CGPoint(x: rect.width/2+15, y: 40))
            path.addLine(to: CGPoint(x: rect.width/2+15, y: 50))
            path.addLine(to: CGPoint(x: rect.width/2, y: 50))
            path.addLine(to: CGPoint(x: rect.width, y: 50))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}


struct PeopleSearchShape : Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width/2-25, y: 0))
            path.addLine(to: CGPoint(x: rect.width/2-25, y: 10))
            path.addLine(to: CGPoint(x: rect.width/2-15, y: 10))
            path.addLine(to: CGPoint(x: rect.width/2-15, y: 20))
            path.addLine(to: CGPoint(x: rect.width/2-5, y: 20))
            path.addLine(to: CGPoint(x: rect.width/2-5, y: 30))
            path.addLine(to: CGPoint(x: rect.width/2+5, y: 30))
            path.addLine(to: CGPoint(x: rect.width/2+5, y: 40))
            path.addLine(to: CGPoint(x: rect.width/2+15, y: 40))
            path.addLine(to: CGPoint(x: rect.width/2+15, y: 50))
            path.addLine(to: CGPoint(x: rect.width/2, y: 50))
            path.addLine(to: CGPoint(x: 0, y: 50))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}
