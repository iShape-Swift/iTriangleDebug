//
//  TriangleTestStore.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import CoreGraphics
import iFixFloat
import iShape
import iDebug

struct ShapeTest {
    let name: String
    let shape: CGShape
}

struct CGShape {
    
    let paths: [[CGPoint]]
    
    init(paths: [[CGPoint]]) {
        self.paths = paths
    }
    
    var shape: FixShape {
        var result = [FixPath]()
        for path in paths {
            result.append(path.map { $0.fix })
        }

        return FixShape(paths: result)
    }
}

extension FixShape {
    func cgShape(scale: Int64) -> CGShape {
        let s = CGFloat(scale)
        var result = [[CGPoint]]()
        for path in paths {
            result.append(path.map { s * $0.cgPoint })
        }

        return CGShape(paths: result)
    }
}

final class TriangleTestStore: TestStore {

    private (set) var pIndex = PersistInt(key: String(describing: TriangleTestStore.self), nilValue: 0)
    
    var onUpdate: (() -> ())?
    
    var tests: [TestHandler] {
        var result = [TestHandler]()
        result.reserveCapacity(data.count)
        
        for i in 0..<data.count {
            result.append(.init(id: i, title: data[i].name))
        }
        
        return result
    }
    
    var testId: Int {
        get {
            pIndex.value
        }
        
        set {
            pIndex.value = newValue
            self.onUpdate?()
        }
    }
    
    var test: ShapeTest {
        data[testId]
    }
    
    let data: [ShapeTest] = {
        let triangulationTests = TriangulationTestBank().loadAll()
        var result = [ShapeTest]()
        result.reserveCapacity(triangulationTests.count)
        for i in 0..<triangulationTests.count {
            let test = triangulationTests[i]
            
            let shape = test.shape.cgShape(scale: test.scale)
            result.append(
                ShapeTest(
                    name: "test_\(i)",
                    shape: shape
                )
            )
        }
        return result
    }()

}
