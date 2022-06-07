//
//  LoginSignUpShapes.swift
//  booksta
//
//  Created by Catalina Besliu on 23.02.2022.
//

import SwiftUI

struct CShapeLeftCurve : Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            //right side curve
            path.move(to: CGPoint(x: rect.width, y: 120))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.closeSubpath()
        }
    }
    
    func stroked() -> some View {
           ZStack {
               self.stroke(Color.red, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
               self.stroke(Color.white, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
           }
       }
}


struct CShapeRightCurve : Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            //right side curve
            path.move(to: CGPoint(x: 0, y: 120))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}
