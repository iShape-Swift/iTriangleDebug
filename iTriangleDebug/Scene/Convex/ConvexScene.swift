//
//  ConvexScene.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 25.10.2023.
//

import SwiftUI
import iDebug
@testable import iTriangle
import iFixFloat
import iShape

struct Edge: Identifiable {
    
    let id: Int
    let a: CGPoint
    let b: CGPoint
    let color: Color
}

final class ConvexScene: ObservableObject, SceneContainer {
    
    static let colorA: Color = .red
    static let colorB: Color = .blue
    
    let id: Int
    let title = "Convex"
    let triangTestStore = TriangleTestStore()
    private (set) var polies: [MPoly] = []
    private (set) var vertices: [TextDot] = []
    private (set) var edges: [Edge] = []
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
    
    func makeView() -> ConvexSceneView {
        ConvexSceneView(scene: self)
    }
    
    func didUpdateTest() {
        let test = triangTestStore.test
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.editors.removeAll()

            var indexOffset = 0
            for path in test.shape.paths {
                let editor = ContourEditor(indexOffset: indexOffset, showIndex: false, color: .black, showArrows: true)
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
        polies.removeAll()
        vertices.removeAll()
        edges.removeAll()
        
        defer {
            self.objectWillChange.send()
        }
        
        guard !editors.isEmpty else { return }

        let paths = editors.map { $0.points }
        let shape = FixShape(paths: paths.map({ $0.map({ Vec(Float($0.x), Float($0.y)).fix }) }))

        let polygons = shape.decomposeToConvexPolygons(validateRule: .evenOdd)
        
        var id = 0
        for polygon in polygons {
            let points = matrix.screen(worldPoints: polygon.path.map({ $0.cgPoint }))
            self.polies.append(MPoly(id: id, color: Color(index: id), points: points))
            id += 1
            
            let pn = polygon.path.count
            for j in 0..<pn {
                let s = polygon.side[j]
                if s == .inner {
                    let a = matrix.screen(worldPoint: polygon.path[j].cgPoint)
                    let b = matrix.screen(worldPoint: polygon.path[(j + 1) % pn].cgPoint)
                    
                    edges.append(Edge(id: edges.count, a: a, b: b, color: .green))
                }
            }
            
        }
        
        let triangulation = shape.triangulate()
        
        for i in 0..<triangulation.points.count {
            let p = matrix.screen(worldPoint: triangulation.points[i].cgPoint)
            vertices.append(
                TextDot(
                    id: i,
                    center: p,
                    radius: 4,
                    color: .black,
                    textColor: .black, font: .system(size: 14), text: "\(i)"
                )
            )
        }

        
    }

    func printTest() {
        var i = 0
        for editor in editors {
            print("\(i): \(editor.points.prettyPrint())")
            i += 1
        }
    }

}
