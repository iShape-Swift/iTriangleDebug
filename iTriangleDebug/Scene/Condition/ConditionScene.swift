//
//  ConditionScene.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 14.08.2023.
//

import SwiftUI
import iDebug
@testable import iTriangle
import iFixFloat
import iShape

final class ConditionScene: ObservableObject, SceneContainer {
    
    let id: Int
    let title = "Condition"
    let conditionTestStore = ConditionTestStore()
    var testStore: TestStore { conditionTestStore }

    private (set) var circle: CircCircle?
    private (set) var main = [CGPoint]()
    private (set) var second = [CGPoint]()
    private (set) var condition: Color = .gray
    private (set) var editor = PointsEditor()
    private (set) var matrix: Matrix = .empty
    
    @Published
    var scale: Float = 10 {
        didSet {
            if !matrix.isZero {
                matrix = Matrix(screenSize: matrix.screenSize, scale: scale, inverseY: true)
                editor.matrix = matrix
                solve()
            }
        }
    }
    
    
    init(id: Int) {
        self.id = id
        conditionTestStore.onUpdate = self.didUpdateTest
        editor.onUpdate = self.didUpdateEditor(_:)
    }
    
    func initSize(screenSize: CGSize) {
        if !matrix.screenSize.isIntSame(screenSize) || Int(scale * 100) != Int(matrix.scale * 100)  {
            matrix = Matrix(screenSize: screenSize, scale: scale, inverseY: true)
            DispatchQueue.main.async { [weak self] in
                self?.solve()
            }
        }
    }
    
    func makeView() -> ConditionSceneView {
        ConditionSceneView(scene: self)
    }
    
    func didUpdateTest() {
        let test = conditionTestStore.test
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.editor.set(points: [test.p0, test.p1, test.p2, test.p3])
            self.solve()
        }
    }
    
    func didUpdateEditor(_ :[CGPoint]) {
        DispatchQueue.main.async { [weak self] in
            self?.solve()
        }
    }
    
    func onAppear() {
        didUpdateTest()
    }

    func solve() {
        main.removeAll()
        second.removeAll()
        circle = nil
        let points = editor.points

        defer {
            self.objectWillChange.send()
        }

        guard !points.isEmpty else { return }
        
        
        let p0 = points[0]
        let p1 = points[1]
        let p2 = points[2]
        let p3 = points[3]
        
        let cond = Delaunay.condition(p0: p0.fix, p1: p1.fix, p2: p2.fix, p3: p3.fix)
        
        if cond {
            self.condition = Color.green
        } else {
            self.condition = Color.red
        }
        
        self.main = matrix.screen(worldPoints: [p1, p2, p3])
        self.second = matrix.screen(worldPoints: [p1, p0, p3])
        
        let c = Self.circumscribedСircle(a: p1, b: p2, c: p3)

        self.circle = CircCircle(
            center: matrix.screen(worldPoint: c.center),
            radius: matrix.screen(world: c.radius)
        )
        
    }

    func printTest() {
        print("\(editor.points.prettyPrint())")
    }

    
    private static func circumscribedСircle(a: CGPoint, b: CGPoint, c: CGPoint) -> CircCircle {
        let d = 2 * (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y))
        let x = ((a.x * a.x + a.y * a.y) * (b.y - c.y) + (b.x * b.x + b.y * b.y) * (c.y - a.y) + (c.x * c.x + c.y * c.y) * (a.y - b.y)) / d
        let y = ((a.x * a.x + a.y * a.y) * (c.x - b.x) + (b.x * b.x + b.y * b.y) * (a.x - c.x) + (c.x * c.x + c.y * c.y) * (b.x - a.x)) / d
        
        let r = ((a.x - x) * (a.x - x) + (a.y - y) * (a.y - y)).squareRoot()
        
        return CircCircle(center: CGPoint(x: x, y: y), radius: r)
    }

    
}

struct CircCircle {
    
    let center: CGPoint
    let radius: CGFloat
}
