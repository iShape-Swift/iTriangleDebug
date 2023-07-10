//
//  TVert.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import SwiftUI
import iDebug

struct TVert: Identifiable {
    
    let id: Int
    let title: String
    let pos: CGPoint
    let color: Color
}


struct TVertView: View {
    
    let vert: TVert
    
    var body: some View {
        ZStack() {
            Circle()
                .size(width: 8, height: 8)
                .offset(vert.pos - CGPoint(x: 4, y: 4))
                .foregroundColor(vert.color)
            Text(vert.title).position(vert.pos + CGPoint(x: 8, y: 16)).foregroundColor(.black)
        }
    }
}
