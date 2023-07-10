//
//  MonotoneSceneView.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import SwiftUI

struct MonotoneSceneView: View {
 
    @ObservedObject
    var scene: MonotoneScene
    
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
                Spacer()
            }
            ForEach(scene.mPolies) { mPoly in
                MPolyView(poly: mPoly)
            }
            ForEach(scene.editors) { editor in
                editor.makeView(matrix: scene.matrix)
            }
            ForEach(scene.verts) { vert in
                TVertView(vert: vert)
            }
        }.onAppear() {
            scene.onAppear()
        }
    }

}
