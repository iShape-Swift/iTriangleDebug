//
//  MonotoneScene.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import SwiftUI
import iDebug
@testable import iTriangle
import iShape
import iFixFloat

final class MonotoneScene: ObservableObject, SceneContainer {
    
    static let colorA: Color = .red
    static let colorB: Color = .blue
    
    let id: Int
    let title = "Monotone Layout"
    let triangTestStore = TriangleTestStore()
    var testStore: TestStore { triangTestStore }
    private (set) var verts: [TVert] = []
    private (set) var editors: [ContourEditor] = []
    
    private (set) var matrix: Matrix = .empty

    private (set) var mPolies: [MPoly] = []
    
    init(id: Int) {
        self.id = id
        triangTestStore.onUpdate = self.didUpdateTest
    }
    
    func initSize(screenSize: CGSize) {
        if !matrix.screenSize.isIntSame(screenSize) {
            matrix = Matrix(screenSize: screenSize, scale: 10, inverseY: true)
            DispatchQueue.main.async { [weak self] in
                self?.solve()
            }
        }
    }
    
    func makeView() -> MonotoneSceneView {
        MonotoneSceneView(scene: self)
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
            self.solve()
        }
    }
    
    func onAppear() {
        didUpdateTest()
    }

    func solve() {
        guard !editors.isEmpty else { return }
        
        let shape = self.shape().flip
        
        let nLayout = shape.nLayout
        
        verts.removeAll()
        var i = 0
        for n in nLayout.specNodes {
            let v = nLayout.navNodes[n.index]
            let p = matrix.screen(worldPoint: v.vert.point.point)
            let color: Color
            let title: String
            switch n.type {
            case .end:
                color = .red
                title = "end (\(i))"
            case .start:
                color = .blue
                title = "start (\(i))"
            case .split:
                color = .orange
                title = "split (\(i))"
            case .merge:
                color = .green
                title = "merge (\(i))"
            }

            verts.append(.init(id: i, title: title, pos: p, color: color))
            i += 1
        }
        
        let layout = shape.mLayout

        mPolies.removeAll()

        var mId = 0
        for start in layout.startList {
            var node = layout.navNodes[start]
            var points = [CGPoint]()
            repeat {
                points.append(matrix.screen(worldPoint: node.vert.point.cgPoint))
                node = layout.navNodes[node.next]
            } while node.index != start
            mPolies.append(.init(id: mId, color: Color(index: mId), points: points))
            mId += 1
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
