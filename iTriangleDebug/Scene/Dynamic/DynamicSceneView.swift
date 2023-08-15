//
//  DynamicSceneView.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 15.08.2023.
//


import SwiftUI
import iDebug

struct DynamicSceneView: View {
 
    @ObservedObject
    var scene: DynamicScene
    
    var body: some View {
        HStack {
            GeometryReader { proxy in
                content(size: proxy.size)
            }
        }
    }
    
    private func content(size: CGSize) -> some View {
        scene.initSize(screenSize: size)
        return ZStack {
            Color.white
            ForEach(scene.triangles) { triangle in
                MPolyView(poly: triangle)
            }
        }.onAppear() {
            scene.onAppear()
        }.onDisappear() {
            scene.onDisappear()
        }
    }

}
