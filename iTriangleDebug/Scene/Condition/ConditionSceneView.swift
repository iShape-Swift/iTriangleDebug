//
//  ConditionSceneView.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 14.08.2023.
//

import SwiftUI
import iDebug

struct ConditionSceneView: View {
 
    @ObservedObject
    var scene: ConditionScene
    
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
            if let circle = scene.circle {
                CircleView(position: circle.center, radius: circle.radius, color: .orange, stroke: 4)
            }
            Path { path in
                path.addLines(scene.main)
                path.closeSubpath()
            }.stroke(style: .init(lineWidth: 4, lineJoin: .round)).foregroundColor(.blue)
            Path { path in
                path.addLines(scene.second)
            }.stroke(style: .init(lineWidth: 4, lineCap: .round, lineJoin: .round)).foregroundColor(scene.condition)
            scene.editor.makeView(matrix: scene.matrix)
        }.onAppear() {
            scene.onAppear()
        }
    }

}
