//
//  ConvexSceneView.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 25.10.2023.
//

import SwiftUI
import iDebug

struct ConvexSceneView: View {
 
    @ObservedObject
    var scene: ConvexScene
    
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
            ForEach(scene.polies) { poly in
                MPolyView(poly: poly)
            }
            ForEach(scene.editors) { editor in
                editor.makeView(matrix: scene.matrix)
            }
            ForEach(scene.vertices) { dot in
                TextDotView(dot: dot)
            }
        }.onAppear() {
            scene.onAppear()
        }
    }

}
