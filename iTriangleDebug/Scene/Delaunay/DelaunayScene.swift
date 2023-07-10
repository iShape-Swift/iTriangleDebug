//
//  DelaunayScene.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import SwiftUI
import iDebug
@testable import iTriangle
import iFixFloat
import iShape

final class DelaunayScene: ObservableObject, SceneContainer {
    
    static let colorA: Color = .red
    static let colorB: Color = .blue
    
    let id: Int
    let title = "Delaunay"
    let triangTestStore = TriangleTestStore()
    private (set) var triangles: [MPoly] = []
    var testStore: TestStore { triangTestStore }

    private (set) var editors: [ContourEditor] = []
    private (set) var matrix: Matrix = .empty
    
    @Published
    var scale: Float = 10 {
        didSet {
            if !matrix.isZero {
                matrix = Matrix(screenSize: matrix.screenSize, scale: scale, inverseY: true)
                for editor in editors {
                    editor.matrix = matrix
                }
                solve()
            }
        }
    }
    
    
    init(id: Int) {
        self.id = id
        triangTestStore.onUpdate = self.didUpdateTest
    }
    
    func initSize(screenSize: CGSize) {
        if !matrix.screenSize.isIntSame(screenSize) || Int(scale * 100) != Int(matrix.scale * 100)  {
            matrix = Matrix(screenSize: screenSize, scale: scale, inverseY: true)
            DispatchQueue.main.async { [weak self] in
                self?.solve()
            }
        }
    }
    
    func makeView() -> DelaunaySceneView {
        DelaunaySceneView(scene: self)
    }
    
    func didUpdateTest() {
        let test = triangTestStore.test
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.editors.removeAll()

            var indexOffset = 0
            for path in test.shape.paths {
                let editor = ContourEditor(indexOffset: indexOffset, showIndex: true, color: .black, showArrows: true)
                editor.set(points: path)
                self.editors.append(editor)
                editor.onUpdate = self.didUpdateEditor
                indexOffset += path.count
            }

            self.solve()
        }
    }
    
    func didUpdateEditor(_ :[CGPoint]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // TODO validate convex
            self.solve()
        }
    }
    
    func onAppear() {
        didUpdateTest()
    }

    func solve() {
        guard !editors.isEmpty else { return }
        
        let shape = self.shape()
        
        let result = shape.triangulate()
        
        triangles.removeAll()
        
        if result.isSuccess {
            var id = 0
            var pnts = [CGPoint](repeating: .zero, count: 3)
            for triangle in result.delaunay.triangles {
                pnts[0] = matrix.screen(worldPoint: triangle.vertices.a.point.cgPoint)
                pnts[1] = matrix.screen(worldPoint: triangle.vertices.b.point.cgPoint)
                pnts[2] = matrix.screen(worldPoint: triangle.vertices.c.point.cgPoint)
                triangles.append(MPoly(id: id, color: Color(index: id), points: pnts))
                id += 1
            }
        }

        self.objectWillChange.send()
    }

    func printTest() {
        var i = 0
        for editor in editors {
            print("\(i): \(editor.points.prettyPrint())")
            i += 1
        }
    }
    
    private func shape() -> FixShape {
        var paths = [[FixVec]]()
        for editor in editors {
            paths.append(editor.points.map({ $0.fix }))
        }
        
        return FixShape(paths: paths)
    }
    
}
