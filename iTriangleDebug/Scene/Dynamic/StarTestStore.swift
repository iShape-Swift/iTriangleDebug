//
//  StarTestStore.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 15.08.2023.
//

import iDebug
import CoreGraphics

struct StarTest {
    let name: String
    let count: Int
    let smallRadius: CGFloat
    let bigRadius: CGFloat
}

final class StarTestStore: TestStore {
    
    private (set) var pIndex = PersistInt(key: String(describing: StarTest.self), nilValue: 0)
    
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
    
    var test: StarTest {
        data[testId]
    }
    
    let data: [StarTest] = [
        .init(
            name: "3 - Star",
            count: 3,
            smallRadius: 7,
            bigRadius: 10
        ),
        .init(
            name: "4 - Star",
            count: 4,
            smallRadius: 5,
            bigRadius: 10
        ),
        .init(
            name: "5 - Star",
            count: 5,
            smallRadius: 5,
            bigRadius: 10
        ),
        .init(
            name: "12 - Star",
            count: 12,
            smallRadius: 5,
            bigRadius: 10
        ),
        .init(
            name: "17 - Star",
            count: 17,
            smallRadius: 2,
            bigRadius: 17
        ),
        .init(
            name: "24 - Star",
            count: 24,
            smallRadius: 20,
            bigRadius: 20.01
        ),
        .init(
            name: "64 - Star",
            count: 64,
            smallRadius: 10,
            bigRadius: 20
        )
    ]
}
