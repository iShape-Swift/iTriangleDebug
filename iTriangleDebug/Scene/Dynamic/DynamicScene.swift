//
//  DynamicScene.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 15.08.2023.
//

import SwiftUI
import iDebug
import iTriangle
import iShape
import iFixFloat

final class DynamicScene: ObservableObject, SceneContainer {
    
    let starTestStore = StarTestStore()
    var testStore: TestStore { starTestStore }
    
    let id: Int
    let title = "Dynamic"

    private var matrix: Matrix = .empty
    private var timer: Timer?
    private var startTime: Date = Date()
    private (set) var triangles: [MPoly] = []
    
    init(id: Int) {
        self.id = id
    }
    
    func initSize(screenSize: CGSize) {
        if !matrix.screenSize.isIntSame(screenSize) {
            matrix = Matrix(screenSize: screenSize, scale: 10, inverseY: true)
            DispatchQueue.main.async { [weak self] in
                self?.solve()
            }
        }
    }
    
    func makeView() -> DynamicSceneView {
        DynamicSceneView(scene: self)
    }
    
    func onAppear() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] timer in
            self?.solve()
        }
    }

    func onDisappear() {
        timer?.invalidate()
        timer = nil
    }
    
    func solve() {
        triangles.removeAll()
        
        defer {
            self.objectWillChange.send()
        }

        let time = Date().timeIntervalSince(startTime)
        let angle = time * 0.1
        let ka = 1.1 + sin(time)
        let kb = 0.5 * ka
        
        let test = starTestStore.test
        
        let scale: CGFloat = 10000
        let iScale: CGFloat = 1 / scale
        
        let pointsA = self.generateStarPoints(
            smallRadius: test.smallRadius * ka,
            bigRadius: test.bigRadius * ka,
            count: test.count,
            angle: angle,
            scale: scale
        ).reversed()

        let pointsB = self.generateStarPoints(
            smallRadius: test.smallRadius * kb,
            bigRadius: test.bigRadius * kb,
            count: test.count,
            angle: angle,
            scale: scale
        ).reversed()
        
        let sA = pointsA.map({ $0.fixVec })
        let sB = pointsB.map({ $0.fixVec })

        let shape = FixShape(contour: sA, holes: [sB])
        let delaunay = shape.delaunay()
        
        
        var i = 0
        var id = 0
        var pnts = [CGPoint](repeating: .zero, count: 3)
        let indices = delaunay.trianglesIndices
        let points = delaunay.points
        while i < indices.count {
            let color = Color(index: id)
            
            let ia = indices[i]
            let ib = indices[i + 1]
            let ic = indices[i + 2]
            
            let a = iScale * points[ia].cgPoint
            let b = iScale * points[ib].cgPoint
            let c = iScale * points[ic].cgPoint
            
            pnts[0] = matrix.screen(worldPoint: a)
            pnts[1] = matrix.screen(worldPoint: b)
            pnts[2] = matrix.screen(worldPoint: c)

            triangles.append(MPoly(id: id, color: Color(index: id), points: pnts))
            id += 1
            
            i += 3
        }

    }
 
    
    private func generateStarPoints(smallRadius: CGFloat, bigRadius: CGFloat, count: Int, angle: Double, scale: CGFloat) -> [CGPoint] {
        let dA = Double.pi / Double(count)
        var a: Double = angle
        
        var points = [CGPoint]()
        points.reserveCapacity(2 * count)
        
        for _ in 0..<count {
            let xR = bigRadius * cos(a)
            let yR = bigRadius * sin(a)
            
            a += dA

            let xr = smallRadius * cos(a)
            let yr = smallRadius * sin(a)
            
            a += dA
            
            points.append(CGPoint(x: xR * scale, y: yR * scale))
            points.append(CGPoint(x: xr * scale, y: yr * scale))
        }
        
        return points
    }
}
