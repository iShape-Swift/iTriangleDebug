//
//  DelaunaySceneView.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import SwiftUI

struct DelaunaySceneView: View {
 
    @ObservedObject
    var scene: DelaunayScene
    
    var body: some View {
        return HStack {
            GeometryReader { proxy in
                content(size: proxy.size)
            }
        }
    }
    
    private func content(size: CGSize) -> some View {
        scene.initSize(screenSize: size)
        return ZStack {
            Color.white
            VStack {
                Button("Print Test") {
                    scene.printTest()
                }.buttonStyle(.borderedProminent).padding()
                Button("Solve") {
                    scene.solve()
                }.buttonStyle(.borderedProminent).padding()
                Slider(value: $scene.scale, in: 5...100).frame(width: 500).padding(.trailing, 8)
                Spacer()
            }
            ForEach(scene.triangles) { triangle in
                MPolyView(poly: triangle)
            }
            ForEach(scene.editors) { editor in
                editor.makeView(matrix: scene.matrix)
            }
        }.onAppear() {
            scene.onAppear()
        }
    }

}
