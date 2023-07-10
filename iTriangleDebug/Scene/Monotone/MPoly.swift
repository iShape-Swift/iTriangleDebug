//
//  MPoly.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import SwiftUI
import iDebug

struct MPoly: Identifiable {
    
    let id: Int
    let color: Color
    let points: [CGPoint]
}

struct MPolyView: View {
    
    let poly: MPoly
    
    var body: some View {
        Path { path in
            path.addLines(poly.points)
            path.closeSubpath()
        }.fill().foregroundColor(poly.color)
    }
}
