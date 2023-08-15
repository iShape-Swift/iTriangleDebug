//
//  ConditionTestStore.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 14.08.2023.
//

import CoreGraphics
import iDebug

struct ConditionTest {
    let name: String
    let p0: CGPoint
    let p1: CGPoint
    let p2: CGPoint
    let p3: CGPoint
}

final class ConditionTestStore: TestStore {
    
    private (set) var pIndex = PersistInt(key: String(describing: ConditionTestStore.self), nilValue: 0)
    
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
    
    var test: ConditionTest {
        data[testId]
    }
    
    let data: [ConditionTest] = [
        .init(
            name: "Test 0",
            p0: CGPoint(x:   0, y: -10),
            p1: CGPoint(x: -10, y:   0),
            p2: CGPoint(x:   0, y:  10),
            p3: CGPoint(x:  10, y:   0)
        )
    ]
    
}
