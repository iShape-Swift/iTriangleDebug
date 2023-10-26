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
    var cgShape: CGShape {
        var result = [[CGPoint]]()
        for path in paths {
            result.append(path.map { $0.cgPoint })
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
    
    let data: [ShapeTest] = [
        .init(
            name: "Convex 1",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y: -15),
                    CGPoint(x: -25, y:   0),
                    CGPoint(x: -15, y:  15),
                    CGPoint(x:  15, y:  15),
                    CGPoint(x:  25, y:   0),
                    CGPoint(x:  15, y: -15)
                ]
            ])
        ),

        .init(
            name: "Convex 2",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -5, y:-15),
                    CGPoint(x:-10, y:  0),
                    CGPoint(x:  0, y: 15),
                    CGPoint(x: 10, y:  5),
                    CGPoint(x:  5, y:-10)
                ]
            ])
        ),
        .init(
            name: "Home",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10.0, y: -10.0),
                    CGPoint(x: -10.0, y: 5.0),
                    CGPoint(x: 0.0, y: 15.0),
                    CGPoint(x: 10.0, y: 5.0),
                    CGPoint(x: 10.0, y: -10.0)
                ]
            ])
        ),
        .init(
            name: "Square",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y: -10),
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:  10, y: -10)
                ]
            ])
        ),
        .init(
            name: "Square with hole",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -20, y: -20),
                    CGPoint(x: -20, y:  20),
                    CGPoint(x:  20, y:  20),
                    CGPoint(x:  20, y: -20)
                ],
                [
                    CGPoint(x: -10, y: -10),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x: -10, y:  10)
                ]
            ])
        ),
        .init(
            name: "Romb",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y:   0),
                    CGPoint(x:   0, y:  15),
                    CGPoint(x:  15, y:   0),
                    CGPoint(x:   0, y: -15)
                ]
            ])
        ),
        .init(
            name: "Romb with hole",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y:   0),
                    CGPoint(x:   0, y:  15),
                    CGPoint(x:  15, y:   0),
                    CGPoint(x:   0, y: -15)
                ],
                [
                    CGPoint(x:  -5, y:   0),
                    CGPoint(x:   0, y:  -5),
                    CGPoint(x:   5, y:   0),
                    CGPoint(x:   0, y:   5)
                ]
            ])
        ),
        .init(
            name: "Arrow 1",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y: -10),
                    CGPoint(x:   0, y:   0),
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  10, y:   0)
                ]
            ])
        ),
        .init(
            name: "Arrow 2",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:   0),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:   0, y:   0),
                    CGPoint(x:  10, y: -10)
                ]
            ])
        ),
        .init(
            name: "X",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:   0),
                    CGPoint(x: -20, y:  20),
                    CGPoint(x:  -5, y:  20),
                    CGPoint(x:   0, y:  10),
                    CGPoint(x:   5, y:  20),
                    CGPoint(x:  20, y:  20),
                    CGPoint(x:  10, y:   0),
                    CGPoint(x:  20, y: -20),
                    CGPoint(x:   5, y: -20),
                    CGPoint(x:   0, y: -10),
                    CGPoint(x:  -5, y: -20),
                    CGPoint(x: -20, y: -20)
                ]
            ])
        ),

        .init(
            name: "Concave 1",
            shape: CGShape(paths: [
                [
                    CGPoint(x:   0, y:  -5),
                    CGPoint(x:   0, y:   0),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x: -10, y: -10)
                ]
            ])
        ),
        .init(
            name: "Concave 2",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y: -15),
                    CGPoint(x: -15, y:   0),
                    CGPoint(x:   0, y:   0),
                    CGPoint(x:   0, y:  15),
                    CGPoint(x:  15, y: -15)
                ]
            ])
        ),
        .init(
            name: "Concave 3",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y: -15),
                    CGPoint(x: -15, y:   0),
                    CGPoint(x:  -1, y:  20),
                    CGPoint(x:   0, y:   5),
                    CGPoint(x:  15, y: -15)
                ]
            ])
        ),
        .init(
            name: "Concave 4",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:   0),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:   0, y:   0),
                    CGPoint(x:  10, y: -20),
                    CGPoint(x: -10, y: -20)
                ]
            ])
        ),
        .init(
            name: "Concave 5",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y: -15),
                    CGPoint(x: -10, y: 0),
                    CGPoint(x: -15, y: 15),
                    CGPoint(x: 15, y: 15),
                    CGPoint(x: 15, y: -15)
                ]
            ])
        ),
        .init(
            name: "Concave 6",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y: -15),
                    CGPoint(x: -15, y:  -5),
                    CGPoint(x: -20, y:  15),
                    CGPoint(x:  15, y:  15),
                    CGPoint(x:  15, y: -15)
                ]
            ])
        ),
        .init(
            name: "Concave 7",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y:   0),
                    CGPoint(x:  -5, y:  10),
                    CGPoint(x: -10, y:  15),
                    CGPoint(x:   5, y:  20),
                    CGPoint(x:  15, y:   0),
                    CGPoint(x:   5, y: -20),
                    CGPoint(x: -10, y: -15),
                    CGPoint(x:  -5, y: -10)
                ]
            ])
        ),
        .init(
            name: "Concave 8",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y:   0),
                    CGPoint(x: -15, y:  10),
                    CGPoint(x: -10, y:  15),
                    CGPoint(x:   5, y:  20),
                    CGPoint(x:  15, y:   0),
                    CGPoint(x:   5, y: -20),
                    CGPoint(x: -10, y: -15),
                    CGPoint(x:  -5, y: -10)
                ]
            ])
        ),
        .init(
            name: "Concave 9",
            shape: CGShape(paths: [
                [
                    CGPoint(x:   5, y:   0),
                    CGPoint(x: -10, y:   5),
                    CGPoint(x: -10, y:  15),
                    CGPoint(x:   5, y:  20),
                    CGPoint(x:  15, y:   0),
                    CGPoint(x:   5, y: -20),
                    CGPoint(x: -10, y: -15),
                    CGPoint(x: -10, y:  -5)
                ]
            ])
        ),
        .init(
            name: "Concave 10",
            shape: CGShape(paths: [
                [
                    CGPoint(x:   0, y:   0),
                    CGPoint(x: -10, y:   5),
                    CGPoint(x: -10, y:  15),
                    CGPoint(x:  10, y:  15),
                    CGPoint(x:   5, y:  10),
                    CGPoint(x:  10, y: -15),
                    CGPoint(x: -10, y: -15),
                    CGPoint(x: -10, y:  -5)
                ]
            ])
        ),
        .init(
            name: "Concave 11",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y:   0),
                    CGPoint(x:  -5, y:  10),
                    CGPoint(x: -10, y:  15),
                    CGPoint(x:   5, y:  20),
                    CGPoint(x:   0, y:   0),
                    CGPoint(x:   5, y: -20),
                    CGPoint(x: -10, y: -15),
                    CGPoint(x:  -5, y: -10)
                ]
            ])
        ),
        .init(
            name: "Concave 12",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y:   0),
                    CGPoint(x:  -5, y:  10),
                    CGPoint(x: -10, y:  15),
                    CGPoint(x:   5, y:  20),
                    CGPoint(x:  -7, y:   0),
                    CGPoint(x:   5, y: -20),
                    CGPoint(x: -10, y: -15),
                    CGPoint(x:  -5, y: -10)
                ]
            ])
        ),
        .init(
            name: "Concave 13",
            shape: CGShape(paths: [
                [
                    CGPoint(x:  -15, y:   0),
                    CGPoint(x:   -5, y:  10),
                    CGPoint(x:  -10, y:  15),
                    CGPoint(x: -2.5, y:  20),
                    CGPoint(x:    5, y:  20),
                    CGPoint(x:  2.5, y:  10),
                    CGPoint(x:    0, y:   0),
                    CGPoint(x:  2.5, y: -10),
                    CGPoint(x:    5, y: -20),
                    CGPoint(x: -2.5, y: -20),
                    CGPoint(x:  -10, y: -15),
                    CGPoint(x:   -5, y: -10)
                ]
            ])
        ),
        .init(
            name: "Concave 14",
            shape: CGShape(paths: [
                [
                    CGPoint(x:  -15, y:   0),
                    CGPoint(x:   -5, y:  10),
                    CGPoint(x:  -10, y:  15),
                    CGPoint(x: -2.5, y:  20),
                    CGPoint(x:    5, y:  20),
                    CGPoint(x: -2.5, y: -15),
                    CGPoint(x:    5, y: -20),
                    CGPoint(x: -2.5, y: -20),
                    CGPoint(x:  -10, y: -15),
                    CGPoint(x:   -5, y: -10)
                ]
            ])
        ),
        .init(
            name: "Concave 15",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  -5, y:   5),
                    CGPoint(x:  10, y:  20),
                    CGPoint(x:  20, y:  20),
                    CGPoint(x:  25, y:  20),
                    CGPoint(x:  25, y:  -5),
                    CGPoint(x:  10, y:  -5),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x: -10, y: -10)
                ]
            ])
        ),
        .init(
            name: "Concave 16",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  -5, y:  15),
                    CGPoint(x:  10, y:  20),
                    CGPoint(x:  20, y:  20),
                    CGPoint(x:  25, y:  20),
                    CGPoint(x:  25, y:  -5),
                    CGPoint(x:  10, y:  -5),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x: -10, y: -10)
                ]
            ])
        ),
        .init(
            name: "Concave 17",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  -5, y:   5),
                    CGPoint(x:  10, y:  20),
                    CGPoint(x:  15, y:  10),
                    CGPoint(x:  25, y:  20),
                    CGPoint(x:  25, y:   0),
                    CGPoint(x:  10, y:   0),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x: -10, y: -10)
                ]
            ])
        ),
        .init(
            name: "Concave 18",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  -5, y:  -5),
                    CGPoint(x:  10, y:  20),
                    CGPoint(x:  15, y:  10),
                    CGPoint(x:  25, y:  20),
                    CGPoint(x:  25, y:   0),
                    CGPoint(x:  10, y:   0),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x: -10, y: -10)
                ]
            ])
        ),
        .init(
            name: "Concave 19",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:  10, y:  20),
                    CGPoint(x:  15, y:  10),
                    CGPoint(x:  25, y:  20),
                    CGPoint(x:  25, y:   0),
                    CGPoint(x:  10, y:   0),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x: -10, y: -10)
                ]
            ])
        ),
        .init(
            name: "Concave 20",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -35, y:   5),
                    CGPoint(x: -20, y:  10),
                    CGPoint(x: -18, y:  20),
                    CGPoint(x:   0, y:  20),
                    CGPoint(x:   5, y:  10),
                    CGPoint(x:  15, y:   5),
                    CGPoint(x:  20, y:  10),
                    CGPoint(x:  35, y:   0),
                    CGPoint(x:  25, y: -10),
                    CGPoint(x:  10, y:  -4),
                    CGPoint(x:  -5, y: -15),
                    CGPoint(x:  -5, y: -20),
                    CGPoint(x: -15, y: -25),
                    CGPoint(x: -20, y: -10),
                    CGPoint(x: -30, y:  -5)
                ]
            ])
        ),
        .init(
            name: "Concave 21",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -35, y:   5),
                    CGPoint(x: -20, y:  10),
                    CGPoint(x: -10, y:  20),
                    CGPoint(x:   0, y:  20),
                    CGPoint(x:   5, y:  10),
                    CGPoint(x:  15, y:   5),
                    CGPoint(x:  20, y:  10),
                    CGPoint(x:  35, y:   0),
                    CGPoint(x:  25, y: -10),
                    CGPoint(x:  10, y:  -4),
                    CGPoint(x:  -5, y: -15),
                    CGPoint(x:  -5, y: -20),
                    CGPoint(x: -15, y: -25),
                    CGPoint(x: -20, y: -10),
                    CGPoint(x: -30, y:  -5)
                ]
            ])
        ),
        .init(
            name: "Concave 22",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y: -10),
                    CGPoint(x: -10, y:  -5),
                    CGPoint(x: -10, y:   0),
                    CGPoint(x: -10, y:   5),
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:  10, y:   5),
                    CGPoint(x:  10, y:   0),
                    CGPoint(x:  10, y:  -5),
                    CGPoint(x:  10, y: -10)
                ]
            ])
        ),
        .init(
            name: "Concave 23",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -20, y:   0),
                    CGPoint(x: -15, y:  15),
                    CGPoint(x: -10, y:  20),
                    CGPoint(x:  -5, y:  15),
                    CGPoint(x:   0, y:  20),
                    CGPoint(x:   5, y:  15),
                    CGPoint(x:  10, y:  20),
                    CGPoint(x:  15, y:  15),
                    CGPoint(x:  25, y:   0),
                    CGPoint(x:  20, y: -15),
                    CGPoint(x:  15, y: -20),
                    CGPoint(x:  10, y: -15),
                    CGPoint(x:   5, y: -20),
                    CGPoint(x:   0, y: -15),
                    CGPoint(x:  -5, y: -20),
                    CGPoint(x: -10, y: -15)
                ]
            ])
        ),
        .init(
            name: "Concave 24",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -20, y:  5),
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  -5, y:  20),
                    CGPoint(x:   0, y:  25),
                    CGPoint(x:   5, y:  15),
                    CGPoint(x:  10, y:   0),
                    CGPoint(x:  15, y:   5),
                    CGPoint(x:  20, y:  -5),
                    CGPoint(x:  15, y: -15),
                    CGPoint(x:   5, y: -25),
                    CGPoint(x:   0, y: -15),
                    CGPoint(x: -10, y: -10),
                    CGPoint(x: -15, y:  -5)
                ]
            ])
        ),
        .init(
            name: "Concave 25",
            shape: CGShape(paths: [
                [
                    CGPoint(x:   -35, y:    5),
                    CGPoint(x: -13.5, y:    8),
                    CGPoint(x:  -9.5, y:   20),
                    CGPoint(x:     3, y:   20),
                    CGPoint(x:   8.5, y:   11),
                    CGPoint(x:    15, y:    5),
                    CGPoint(x:    32, y: 14.5),
                    CGPoint(x:    35, y:    0),
                    CGPoint(x:    25, y:  -10),
                    CGPoint(x:     0, y:  1.5),
                    CGPoint(x:  -0.5, y: -12.5),
                    CGPoint(x:    -5, y:   -20),
                    CGPoint(x:  -7.5, y:   2.5),
                    CGPoint(x:   -31, y:    -4)
                ]
            ])
        ),
        .init(
            name: "Concave 26",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:  5),
                    CGPoint(x:  -5, y:  5),
                    CGPoint(x:   0, y:  0),
                    CGPoint(x:   5, y:  5),
                    CGPoint(x:  10, y:  5),
                    CGPoint(x:  10, y: -5),
                    CGPoint(x:   5, y: -5),
                    CGPoint(x:   0, y:  0),
                    CGPoint(x:  -5, y: -5),
                    CGPoint(x: -10, y: -5)
                ]
            ])
        ),
        .init(
            name: "Concave 27",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -0.5, y:  -5),
                    CGPoint(x:  -10, y:   0),
                    CGPoint(x:  -10, y:  10),
                    CGPoint(x:   20, y:  10),
                    CGPoint(x:   10, y:   5),
                    CGPoint(x:   10, y:   0),
                    CGPoint(x:    5, y:   5),
                    CGPoint(x:    0, y: -15)
                ]
            ])
        ),
        .init(
            name: "Concave 28",
            shape: CGShape(paths: [
                [
                    CGPoint(x:  -5, y:  -5),
                    CGPoint(x: -20, y:  10),
                    CGPoint(x:  20, y:  10),
                    CGPoint(x:  15, y:  -5),
                    CGPoint(x:   5, y:   5),
                    CGPoint(x:   0, y: -15)
                ]
            ])
        ),
        .init(
            name: "Concave 29",
            shape: CGShape(paths: [
                [
                    CGPoint(x:  -15, y:  15),
                    CGPoint(x:    3, y:  15),
                    CGPoint(x:    5, y:   5),
                    CGPoint(x:   10, y:  -4),
                    CGPoint(x:   17, y:  -8),
                    CGPoint(x:    9, y: -10),
                    CGPoint(x:  8.5, y:  -7),
                    CGPoint(x:   -5, y:   2)
                ]
            ])
        ),
        .init(
            name: "Complex 1",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -40, y:  40),
                    CGPoint(x:  40, y:  40),
                    CGPoint(x:  40, y: -40),
                    CGPoint(x: -40, y: -40)
                ],
                [
                    CGPoint(x:   5, y:   0),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x:  25, y:   0),
                    CGPoint(x:  15, y:   5)
                ],
                [
                    CGPoint(x: -15, y: -25),
                    CGPoint(x:   5, y: -15),
                    CGPoint(x:  -5, y:  -5),
                    CGPoint(x:   5, y:  10),
                    CGPoint(x:   5, y:  20),
                    CGPoint(x: -15, y:  20)
                ]
            ])
        ),
        .init(
            name: "Complex 2",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -5, y:   0),
                    CGPoint(x: -25, y:  15),
                    CGPoint(x:  20, y:  15),
                    CGPoint(x:  20, y: -15),
                    CGPoint(x: -25, y: -15)
                ],
                [
                    CGPoint(x: -15, y: -10),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:   0, y:   0)
                ]
            ])
        ),
        .init(
            name: "Complex 3",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -25, y:  5),
                    CGPoint(x: -30, y:  20),
                    CGPoint(x: -25, y:  30),
                    CGPoint(x: -10, y:  25),
                    CGPoint(x:   0, y:  30),
                    CGPoint(x:  15, y:  15),
                    CGPoint(x:  30, y:  15),
                    CGPoint(x:  35, y:   5),
                    CGPoint(x:  30, y: -10),
                    CGPoint(x:  25, y: -10),
                    CGPoint(x:  15, y: -20),
                    CGPoint(x:  15, y: -30),
                    CGPoint(x:  -5, y: -35),
                    CGPoint(x: -15, y: -20),
                    CGPoint(x: -40, y: -25),
                    CGPoint(x: -35, y:  -5)
                ],
                [
                    CGPoint(x:   5, y:   0),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x:  25, y:   0),
                    CGPoint(x:  15, y:   5)
                ],
                [
                    CGPoint(x: -15, y:   0),
                    CGPoint(x: -25, y:  -5),
                    CGPoint(x: -30, y: -15),
                    CGPoint(x: -15, y: -10),
                    CGPoint(x:  -5, y: -15),
                    CGPoint(x:   0, y: -25),
                    CGPoint(x:   5, y: -15),
                    CGPoint(x:  -5, y:  -5),
                    CGPoint(x:  -5, y:   5),
                    CGPoint(x:   5, y:  10),
                    CGPoint(x:   0, y:  20),
                    CGPoint(x:  -5, y:  15),
                    CGPoint(x: -10, y:  15),
                    CGPoint(x: -15, y:  20),
                    CGPoint(x: -20, y:  10),
                    CGPoint(x: -15, y:   5)
                ]
            ])
        ),
        .init(
            name: "Complex 4",
            shape: CGShape(paths: [
                [
                    CGPoint(x:  -5, y:  10),
                    CGPoint(x:   5, y:  10),
                    CGPoint(x:  10, y:   5),
                    CGPoint(x:  10, y:  -5),
                    CGPoint(x:   5, y: -10),
                    CGPoint(x:  -5, y: -10),
                    CGPoint(x: -10, y:  -5),
                    CGPoint(x: -10, y:   5)
                ],
                [
                    CGPoint(x:  -5, y:   0),
                    CGPoint(x:   0, y:  -5),
                    CGPoint(x:   5, y:   0),
                    CGPoint(x:   0, y:   5)
                ]
            ])
        ),
        .init(
            name: "Complex 5",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y: -10),
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:  10, y: -10)
                ],
                [
                    CGPoint(x:   0, y:  -5),
                    CGPoint(x:   5, y:  -5),
                    CGPoint(x:   5, y:   5),
                    CGPoint(x:   0, y:   5)
                ],
                [
                    CGPoint(x:  -5, y:  -5),
                    CGPoint(x:   0, y:  -5),
                    CGPoint(x:   0, y:   5),
                    CGPoint(x:  -5, y:   5)
                ]
            ])
        ),
        .init(
            name: "Complex 6",
            shape: CGShape(paths: [
                [
                    CGPoint(x:  0,  y:   0),
                    CGPoint(x:  -5, y:   5),
                    CGPoint(x:  -5, y:  10),
                    CGPoint(x:   5, y:  10),
                    CGPoint(x:   5, y:   5),
                    CGPoint(x:   0, y:   0),
                    CGPoint(x:   5, y:  -5),
                    CGPoint(x:   5, y: -10),
                    CGPoint(x:  -5, y: -10),
                    CGPoint(x:  -5, y:  -5)
                ]
            ])
        ),
        .init(
            name: "Complex 7",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y: -10),
                    CGPoint(x: -15, y:  10),
                    CGPoint(x:  15, y:  10),
                    CGPoint(x:  15, y: -10)
                ],
                [
                    CGPoint(x: -10, y:   0),
                    CGPoint(x:  -5, y:  -5),
                    CGPoint(x:   0, y:   0),
                    CGPoint(x:  -5, y:   5)
                ],
                [
                    CGPoint(x:   0, y:   0),
                    CGPoint(x:   5, y:  -5),
                    CGPoint(x:  10, y:   0),
                    CGPoint(x:   5, y:   5)
                ]
            ])
        ),
        .init(
            name: "Complex 8",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:  15),
                    CGPoint(x:  10, y:  15),
                    CGPoint(x:  10, y: -15),
                    CGPoint(x: -10, y: -15)
                ],
                [
                    CGPoint(x:  -5, y:   5),
                    CGPoint(x:   0, y:   0),
                    CGPoint(x:   5, y:   5),
                    CGPoint(x:   0, y:  10)
                ],
                [
                    CGPoint(x:  -5, y:  -5),
                    CGPoint(x:   0, y: -10),
                    CGPoint(x:   5, y:  -5),
                    CGPoint(x:   0, y:   0)
                ]
            ])
        ),
        .init(
            name: "Complex 9",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  -5, y:  10),
                    CGPoint(x:   0, y:   5),
                    CGPoint(x:   5, y:  10),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x: -10, y: -10)
                ],
                [
                    CGPoint(x:  -5, y:   0),
                    CGPoint(x:   0, y:  -5),
                    CGPoint(x:   5, y:   0),
                    CGPoint(x:   0, y:   5)
                ]
            ])
        ),
        .init(
            name: "Complex 10",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x:   5, y: -10),
                    CGPoint(x:   0, y:  -5),
                    CGPoint(x:  -5, y: -10),
                    CGPoint(x: -10, y: -10)
                ],
                [
                    CGPoint(x:  -5, y:   0),
                    CGPoint(x:   0, y:  -5),
                    CGPoint(x:   5, y:   0),
                    CGPoint(x:   0, y:   5)
                ]
            ])
        ),
        .init(
            name: "Complex 11",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  -5, y:  10),
                    CGPoint(x:   0, y:   5),
                    CGPoint(x:   5, y:  10),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x:   5, y: -10),
                    CGPoint(x:   0, y:  -5),
                    CGPoint(x:  -5, y: -10),
                    CGPoint(x: -10, y: -10)
                ],
                [
                    CGPoint(x:  -5, y:   0),
                    CGPoint(x:   0, y:  -5),
                    CGPoint(x:   5, y:   0),
                    CGPoint(x:   0, y:   5)
                ]
            ])
        ),
        .init(
            name: "Complex 12",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:   0, y:   5),
                    CGPoint(x:   5, y:   0),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x: -10, y: -10)
                ]
            ])
        ),
        .init(
            name: "Complex 13",
            shape: CGShape(paths: [
                [
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x:   5, y:   0),
                    CGPoint(x:   0, y:  -5),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x: -10, y: -10),
                    CGPoint(x: -10, y:  10)
                ]
            ])
        ),
        .init(
            name: "Complex 14",
            shape: CGShape(paths: [
                [
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x: -10, y: -10),
                    CGPoint(x:   0, y:  -5),
                    CGPoint(x:  -5, y:   0),
                    CGPoint(x: -10, y: -10),
                    CGPoint(x: -10, y:  10)
                ]
            ])
        ),
        .init(
            name: "Complex 15",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  -5, y:   0),
                    CGPoint(x:   0, y:   5),
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x: -10, y: -10)
                ]
            ])
        ),
        .init(
            name: "Complex 16",
            shape: CGShape(paths: [
                [
                    CGPoint(x: 10.0, y:  10.0),
                    CGPoint(x: 10.0, y:  -5.0),
                    CGPoint(x:  1.0, y:   0.0),
                    CGPoint(x:  5.0, y:  -5.0),
                    CGPoint(x:  3.0, y:  -5.0),
                    CGPoint(x:  5.0, y: -10.0),
                    CGPoint(x:-10.0, y: -10.0)
                ]
            ])
        ),
        .init(
            name: "Complex 17",
            shape: CGShape(paths: [
                [
                    CGPoint(x: 10.0, y:  8.0),
                    CGPoint(x: 15.0, y: -1.0),
                    CGPoint(x:  6.0, y:  3.0),
                    CGPoint(x: 10.0, y:  0.0),
                    CGPoint(x:  8.0, y:  0.0),
                    CGPoint(x:  9.0, y: -2.0),
                    CGPoint(x: -5.0, y: -2.0),
                ]
            ])
        ),
        .init(
            name: "Complex 18",
            shape: CGShape(paths: [
                [
                    CGPoint(x: 10.6, y:  8.3),
                    CGPoint(x:  9.8, y:  5.4),
                    CGPoint(x: 14.2, y:  3.4),
                    CGPoint(x: 13.0, y:    0),
                    CGPoint(x: 14.2, y:  1.2),
                    CGPoint(x: 15.2, y: -1.2),
                    CGPoint(x:  6.2, y:  2.4),
                    CGPoint(x: 10.6, y: -0.5),
                    CGPoint(x:  7.9, y:  1.0),
                    CGPoint(x:  8.6, y: -2.0),
                    CGPoint(x:  4.2, y: -1.7),
                    CGPoint(x:  4.2, y: -5.1),
                    CGPoint(x: -0.9, y: -5.6),
                    CGPoint(x:    0, y: -3.9),
                    CGPoint(x: -3.6, y: -4.2),
                    CGPoint(x: -2.1, y: -1.5),
                    CGPoint(x: -5.0, y: -1.7),
                    CGPoint(x: -2.8, y: -0.3),
                    CGPoint(x: -3.6, y:  2.0),
                    CGPoint(x:-10.7, y:  4.2),
                    CGPoint(x:-11.9, y:  1.0),
                    CGPoint(x:-14.1, y:  3.9),
                    CGPoint(x:-11.4, y:  3.4),
                    CGPoint(x:-10.9, y:  6.6),
                    CGPoint(x: -6.3, y:  7.3),
                    CGPoint(x: -1.2, y:  3.7),
                    CGPoint(x:  8.1, y:  4.2)
                ]
            ])
        ),
        .init(
            name: "Complex 19",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -30, y:   0),
                    CGPoint(x: -30, y:  30),
                    CGPoint(x:   0, y:  30),
                    CGPoint(x:  30, y:  30),
                    CGPoint(x:  15, y:   0),
                    CGPoint(x:  30, y: -30),
                    CGPoint(x:   0, y: -30),
                    CGPoint(x: -30, y: -30)
                ],
                [
                    CGPoint(x: -15, y: -15),
                    CGPoint(x:  18, y: -15),
                    CGPoint(x:  10, y:  15),
                    CGPoint(x: -15, y:  15)
                ]
            ])
        ),
        .init(
            name: "Complex 20",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y:   0),
                    CGPoint(x: -30, y:  30),
                    CGPoint(x:  30, y:  30),
                    CGPoint(x:  30, y: -30),
                    CGPoint(x:   0, y: -30),
                    CGPoint(x: -30, y: -30)
                ],
                [
                    CGPoint(x:  10, y:  -8),
                    CGPoint(x: -10, y: -13),
                    CGPoint(x:  19, y: -11),
                    CGPoint(x: -12, y:  15),
                    CGPoint(x:  19, y:  18),
                    CGPoint(x: -20, y:  18)
                ]
            ])
        ),
        .init(
            name: "Complex 21",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -20, y: -20),
                    CGPoint(x: -20, y:  20),
                    CGPoint(x:  20, y:  20),
                    CGPoint(x:  20, y: -20)
                ],
                [
                    CGPoint(x:   0, y:  20),
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:   0, y:   0),
                    CGPoint(x:  10, y:  10)
                ]
            ])
        ),
        .init(
            name: "Complex 22",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -20, y: -20),
                    CGPoint(x: -20, y:  20),
                    CGPoint(x:  20, y:  20),
                    CGPoint(x:  20, y: -20)
                ],
                [
                    CGPoint(x:   0, y:  20),
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  10, y: -10),
                    CGPoint(x: -10, y: -10),
                    CGPoint(x:  10, y:  10)
                ]
            ])
        ),
        .init(
            name: "Complex 23",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -20, y: -20),
                    CGPoint(x: -20, y:  20),
                    CGPoint(x:  20, y:  20),
                    CGPoint(x:  20, y: -20)
                ],
                [
                    CGPoint(x:   0, y:  20),
                    CGPoint(x: -10, y:  10),
                    CGPoint(x:  10, y:  10),
                    CGPoint(x:   0, y:   0)
                ]
            ])
        ),
        .init(
            name: "Complex 24",
            shape: FixShape(paths: [
                [
                    FixVec(0, 20480),
                    FixVec(20480, -20480),
                    FixVec(-20480, -20480),
                ],
                [
                    FixVec(    0,      0),
                    FixVec(10240,      0),
                    FixVec(    0, -10240),
                    FixVec(10240, -10240),
                ]
            ]).cgShape
        ),
        .init(
            name: "Complex 25",
            shape: FixShape(paths: [
                [
                    FixVec(0, 20480),
                    FixVec(9216, 1024),
                    FixVec(14336, -15360),
                    FixVec(-14336, -15360),
                ],
                [
                    FixVec(-4096, -5120),
                    FixVec(9216, 1024),
                    FixVec(2048, -11264),
                    FixVec(5120, -9216),
                ]
            ]).cgShape
        ),
        .init(
            name: "Complex 26",
            shape: FixShape(paths: [
                [
                    FixVec(0, 20480),
                    FixVec(9216, 1024),
                    FixVec(26624, -7168),
                    FixVec(14336, -15360),
                    FixVec(-14336, -15360),
                    FixVec(-25600, -7168),
                ],
                [
                    FixVec(-4096, -5120),
                    FixVec(9216, 1024),
                    FixVec(2048, -11264),
                ]
            ]).cgShape
        ),
        .init(
            name: "Complex 27",
            shape: FixShape(paths: [
                [
                    FixVec(0, 20480),
                    FixVec(14336, -15360),
                    FixVec(-14336, -15360),
                    FixVec(-18432, 0),
                    FixVec(-7168, 6144),
                    FixVec(-10240, 8192)
                ],
                [
                    FixVec(-2048, -2048),
                    FixVec(-9216, 10240),
                    FixVec(-2048, -9216),
                ]
            ]).cgShape
        ),
        .init(
            name: "Complex 28",
            shape: FixShape(paths: [
                [
                    FixVec(0, 20480),
                    FixVec(8192, 10240),
                    FixVec(7168, 6144),
                    FixVec(9216, 1024),
                    FixVec(13312, -1024),
                    FixVec(17408, 1024),
                    FixVec(26624, -7168),
                    FixVec(14336, -15360),
                    FixVec(0, -18432),
                    FixVec(-14336, -15360),
                    FixVec(-25600, -7168),
                    FixVec(-18432, 0),
                    FixVec(-16384, -3072),
                    FixVec(-13312, -4096),
                    FixVec(-8192, -2048),
                    FixVec(-6144, 2048),
                    FixVec(-7168, 6144),
                    FixVec(-10240, 8192)
                ],
                [
                    FixVec(2048, 0),
                    FixVec(-2048, -2048),
                    FixVec(-9216, 10240),
                    FixVec(-2048, -9216),
                    FixVec(2048, -11264),
                    FixVec(5120, -9216),
                    FixVec(7168, -5120),
                    FixVec(5120, -2048)
                ]
            ]).cgShape
        ),
        .init(
            name: "Star 1",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y:   0),
                    CGPoint(x: -30, y:  30),
                    CGPoint(x:   0, y:  15),
                    CGPoint(x:  30, y:  30),
                    CGPoint(x:  15, y:   0),
                    CGPoint(x:  30, y: -30),
                    CGPoint(x:   0, y: -15),
                    CGPoint(x: -30, y: -30)
                ],
                [
                    CGPoint(x: -10, y:   0),
                    CGPoint(x:   0, y: -10),
                    CGPoint(x:  10, y:   0),
                    CGPoint(x:   0, y:  10)
                ]
            ])
        ),
        .init(
            name: "Star 2",
            shape: CGShape(paths: [
                [
                    CGPoint(x: -15, y:   0),
                    CGPoint(x: -30, y:  30),
                    CGPoint(x:   0, y:  15),
                    CGPoint(x:  30, y:  30),
                    CGPoint(x:  15, y:   0),
                    CGPoint(x:  30, y: -30),
                    CGPoint(x:   0, y: -15),
                    CGPoint(x: -30, y: -30)
                ],
                [
                    CGPoint(x: -10, y:   0),
                    CGPoint(x: -20, y: -20),
                    CGPoint(x:   0, y: -10),
                    CGPoint(x:  20, y: -20),
                    CGPoint(x:  10, y:   0),
                    CGPoint(x:  20, y:  20),
                    CGPoint(x:   0, y:  10),
                    CGPoint(x: -20, y:  20)
                ]
            ])
        ),
        .init(
            name: "Star 3",
            shape: CGShape(paths: [
                [
                    CGPoint(x:32, y: 0),                  // 0
                    CGPoint(x:21.02803, y: -4.182736),
                    CGPoint(x:29.56414, y: -12.24587),
                    CGPoint(x:35.38735, y: -23.64507),
                    CGPoint(x:22.62741, y: -22.62741),
                    CGPoint(x:11.91142, y: -17.82671),    // 5
                    CGPoint(x:12.24587, y: -29.56414),
                    CGPoint(x:8.303045, y: -41.74222),
                    CGPoint(x:0, y: -32),
                    CGPoint(x:-4.182734, y: -21.02804),
                    CGPoint(x:-12.24586, y: -29.56413),   // 10
                    CGPoint(x:-23.64507, y: -35.38735),
                    CGPoint(x:-22.62742, y: -22.62742),
                    CGPoint(x:-17.82671, y: -11.91142),
                    CGPoint(x:-29.56416, y: -12.24587),
                    CGPoint(x:-41.74223, y: -8.303034),   // 15
                    CGPoint(x:-32, y: 0),
                    CGPoint(x:-21.02803, y: 4.182745),    // 17
                    CGPoint(x:-29.56418, y: 12.2459),
                    CGPoint(x:-35.38733, y: 23.64509),
                    CGPoint(x:-22.62736, y: 22.62739),    // 20
                    CGPoint(x:-11.91141, y: 17.82672),    // 21
                    CGPoint(x:-12.24587, y: 29.56422),
                    CGPoint(x:-8.303008, y: 41.74223),
                    CGPoint(x:0, y: 32),
                    CGPoint(x:4.182758, y: 21.02803),     // 25
                    CGPoint(x:12.24594, y: 29.56422),
                    CGPoint(x:23.64511, y: 35.38732),
                    CGPoint(x:22.62737, y: 22.62731),
                    CGPoint(x:17.82672, y: 11.9114),
                    CGPoint(x:29.56428, y: 12.24587),     // 30
                    CGPoint(x:41.74223, y: 8.30298)
                ],
                [
                   CGPoint(x:20.87112, y: 4.15149),
                   CGPoint(x:14.78214, y: 6.122937),
                   CGPoint(x:8.913362, y: 5.9557),
                   CGPoint(x:11.31368, y: 11.31366),     // 35
                   CGPoint(x:11.82256, y: 17.69366),
                   CGPoint(x:6.12297, y: 14.78211),
                   CGPoint(x:2.091379, y: 10.51402),
                   CGPoint(x:0, y: 16),
                   CGPoint(x:-4.151504, y: 20.87111),    // 40
                   CGPoint(x:-6.122936, y: 14.78211),
                   CGPoint(x:-5.955706, y: 8.913358),
                   CGPoint(x:-11.31368, y: 11.3137),     // 43
                   CGPoint(x:-17.69367, y: 11.82255),
                   CGPoint(x:-14.78209, y: 6.12295),     // 45
                   CGPoint(x:-10.51402, y: 2.091372),
                   CGPoint(x:-16, y: 0),
                   CGPoint(x:-20.87111, y: -4.151517),   // 48
                   CGPoint(x:-14.78208, y: -6.122935),
                   CGPoint(x:-8.913354, y: -5.955712),
                   CGPoint(x:-11.31371, y: -11.31371),
                   CGPoint(x:-11.82253, y: -17.69367),
                   CGPoint(x:-6.12293, y: -14.78207),
                   CGPoint(x:-2.091367, y: -10.51402),
                   CGPoint(x:0, y: -16),
                   CGPoint(x:4.151523, y: -20.87111),
                   CGPoint(x:6.122935, y: -14.78207),
                   CGPoint(x:5.955712, y: -8.913354),
                   CGPoint(x:11.31371, y: -11.31371),
                   CGPoint(x:17.69367, y: -11.82254),
                   CGPoint(x:14.78207, y: -6.122935),
                   CGPoint(x:10.51402, y: -2.091368),
                   CGPoint(x:16, y: 0)
                ]
            ])
        ),
        .init(
            name: "Star 4",
            shape: CGShape(paths: [
                [
                    CGPoint(x:32, y: 0),                  // 0
                    CGPoint(x:16.63412, y: -3.308732),    // 1
                    CGPoint(x:29.56414, y: -12.24587),    // 2
                    CGPoint(x:39.11233, y: -26.13403),    // 3
                    CGPoint(x:22.62741, y: -22.62741),    // 4
                    CGPoint(x:9.42247, y: -14.10172),     // 5
                    CGPoint(x:12.24587, y: -29.56414),    // 6
                    CGPoint(x:9.177051, y: -46.13614),    // 7
                    CGPoint(x:0, y: -32),                 // 8
                    CGPoint(x:-3.30873, y: -16.63412),    // 9
                    CGPoint(x:-12.24586, y: -29.56413),   // 10
                    CGPoint(x:-26.13402, y: -39.11234),   // 11
                    CGPoint(x:-22.62742, y: -22.62742),   // 12
                    CGPoint(x:-14.10172, y: -9.42247),    // 13
                    CGPoint(x:-29.56417, y: -12.24587),   // 14
                    CGPoint(x:-46.13614, y: -9.177038),   // 15
                    CGPoint(x:-32, y: 0),                 // 16
                    CGPoint(x:-16.63412, y: 3.308738),    // 17
                    CGPoint(x:-29.56419, y: 12.24591),    // 18
                    CGPoint(x:-39.11232, y: 26.13405),    // 19
                    CGPoint(x:-22.62735, y: 22.62738),    // 20
                    CGPoint(x:-9.422461, y: 14.10173),    // 21
                    CGPoint(x:-12.24588, y: 29.56424),    // 22
                    CGPoint(x:-9.177009, y: 46.13615),    // 23
                    CGPoint(x:0, y: 32),                  // 24
                    CGPoint(x:3.308749, y: 16.63411),     // 25
                    CGPoint(x:12.24596, y: 29.56426),     // 26
                    CGPoint(x:26.13407, y: 39.1123),      // 27
                    CGPoint(x:22.62734, y: 22.62728),     // 28
                    CGPoint(x:14.10174, y: 9.422452),     // 29
                    CGPoint(x:29.56433, y: 12.24589),     // 30
                    CGPoint(x:46.13615, y: 9.176978)      // 31
                ],
                [
                    CGPoint(x:23.06808, y: 4.588489),     // 32
                    CGPoint(x:14.78216, y: 6.122947),     // 33
                    CGPoint(x:7.050869, y: 4.711226),     // 34
                    CGPoint(x:11.31367, y: 11.31364),     // 35
                    CGPoint(x:13.06704, y: 19.55615),     // 36
                    CGPoint(x:6.122978, y: 14.78213),     // 37
                    CGPoint(x:1.654375, y: 8.317057),     // 38
                    CGPoint(x:0, y: 16),                  // 39
                    CGPoint(x:-4.588504, y: 23.06807),    // 40
                    CGPoint(x:-6.122941, y: 14.78212),    // 41
                    CGPoint(x:-4.71123, y: 7.050865),     // 42
                    CGPoint(x:-11.31367, y: 11.31369),    // 43
                    CGPoint(x:-19.55616, y: 13.06702),    // 44
                    CGPoint(x:-14.7821, y: 6.122953),     // 45
                    CGPoint(x:-8.317058, y: 1.654369),    // 46
                    CGPoint(x:-16, y: 0),                 // 47
                    CGPoint(x:-23.06807, y: -4.588519),   // 48
                    CGPoint(x:-14.78208, y: -6.122936),   // 49
                    CGPoint(x:-7.050862, y: -4.711235),   // 50
                    CGPoint(x:-11.31371, y: -11.31371),   // 51
                    CGPoint(x:-13.06701, y: -19.55617),   // 52
                    CGPoint(x:-6.122929, y: -14.78206),   // 53
                    CGPoint(x:-1.654365, y: -8.317059),   // 54
                    CGPoint(x:0, y: -16),                 // 55
                    CGPoint(x:4.588525, y: -23.06807),    // 56
                    CGPoint(x:6.122935, y: -14.78207),    // 57
                    CGPoint(x:4.711235, y: -7.050862),    // 58
                    CGPoint(x:11.31371, y: -11.31371),    // 59
                    CGPoint(x:19.55617, y: -13.06701),    // 60
                    CGPoint(x:14.78207, y: -6.122935),    // 61
                    CGPoint(x:8.317059, y: -1.654366),    // 62
                    CGPoint(x:16, y: 0)                   // 63
                ]
            ])
        ),
        .init(
            name: "Star 5",
            shape: CGShape(paths: TriangleTestStore.star(count: 128, radius: 16, k: 0.5))
        ),
        .init(
            name: "Eagle",
            shape: CGShape(paths: [
                [
                   CGPoint(x: 0.0, y: -18.0),
                   CGPoint(x: -2.8, y: -19.6),
                   CGPoint(x: -4.8, y: -19.6),
                   CGPoint(x: -3.6, y: -17.6),
                   CGPoint(x: -6.4, y: -18.0),
                   CGPoint(x: -9.2, y: -16.8),
                   CGPoint(x: -7.6, y: -15.2),
                   CGPoint(x: -10.4, y: -15.6),
                   CGPoint(x: -12.8, y: -13.6),
                   CGPoint(x: -10.4, y: -12.8),
                   CGPoint(x: -13.6, y: -12.4),
                   CGPoint(x: -15.2, y: -10.8),
                   CGPoint(x: -14.0, y: -10.0),
                   CGPoint(x: -16.0, y: -9.6),
                   CGPoint(x: -17.2, y: -7.2),
                   CGPoint(x: -12.8, y: -6.8),
                   CGPoint(x: -7.2, y: -4.0),
                   CGPoint(x: -7.6, y: -1.2),
                   CGPoint(x: -8.4, y: 0.8),
                   CGPoint(x: -8.8, y: -0.4),
                   CGPoint(x: -10.0, y: -1.2),
                   CGPoint(x: -10.4, y: 1.2),
                   CGPoint(x: -10.8, y: 0.0),
                   CGPoint(x: -12.8, y: -1.6),
                   CGPoint(x: -12.8, y: 1.2),
                   CGPoint(x: -13.6, y: -0.4),
                   CGPoint(x: -16.4, y: -2.0),
                   CGPoint(x: -16.0, y: 0.4),
                   CGPoint(x: -18.4, y: -1.2),
                   CGPoint(x: -18.4, y: 1.2),
                   CGPoint(x: -21.2, y: -0.4),
                   CGPoint(x: -20.8, y: 1.6),
                   CGPoint(x: -23.6, y: 0.4),
                   CGPoint(x: -23.2, y: 2.8),
                   CGPoint(x: -26.0, y: 1.6),
                   CGPoint(x: -25.2, y: 3.6),
                   CGPoint(x: -29.2, y: 2.4),
                   CGPoint(x: -28.4, y: 4.4),
                   CGPoint(x: -32.4, y: 3.6),
                   CGPoint(x: -31.0, y: 6.4),
                   CGPoint(x: -35.2, y: 6.0),
                   CGPoint(x: -34.0, y: 7.2),
                   CGPoint(x: -37.6, y: 7.6),
                   CGPoint(x: -35.6, y: 9.2),
                   CGPoint(x: -38.4, y: 8.8),
                   CGPoint(x: -41.2, y: 9.2),
                   CGPoint(x: -39.2, y: 10.8),
                   CGPoint(x: -42.0, y: 10.8),
                   CGPoint(x: -44.8, y: 12.0),
                   CGPoint(x: -41.2, y: 13.6),
                   CGPoint(x: -45.2, y: 13.6),
                   CGPoint(x: -47.6, y: 15.2),
                   CGPoint(x: -42.8, y: 16.4),
                   CGPoint(x: -46.8, y: 17.2),
                   CGPoint(x: -48.8, y: 19.6),
                   CGPoint(x: -44.0, y: 19.6),
                   CGPoint(x: -40.8, y: 20.0),
                   CGPoint(x: -42.8, y: 20.4),
                   CGPoint(x: -46.0, y: 23.4),
                   CGPoint(x: -48.0, y: 25.6),
                   CGPoint(x: -42.0, y: 23.2),
                   CGPoint(x: -36.8, y: 22.0),
                   CGPoint(x: -38.4, y: 23.6),
                   CGPoint(x: -39.6, y: 26.4),
                   CGPoint(x: -39.6, y: 30.4),
                   CGPoint(x: -37.6, y: 26.4),
                   CGPoint(x: -28.0, y: 22.4),
                   CGPoint(x: -30.0, y: 24.4),
                   CGPoint(x: -30.0, y: 26.8),
                   CGPoint(x: -28.4, y: 24.8),
                   CGPoint(x: -21.2, y: 22.0),
                   CGPoint(x: -11.0, y: 13.6),
                   CGPoint(x: -8.4, y: 12.4),
                   CGPoint(x: -6.0, y: 12.4),
                   CGPoint(x: -4.0, y: 12.8),
                   CGPoint(x: -2.4, y: 14.0),
                   CGPoint(x: -0.0, y: 14.4),
                   CGPoint(x: 2.4, y: 14.0),
                   CGPoint(x: 4.0, y: 12.8),
                   CGPoint(x: 6.0, y: 12.4),
                   CGPoint(x: 8.4, y: 12.4),
                   CGPoint(x: 11.0, y: 13.6),
                   CGPoint(x: 21.2, y: 22.0),
                   CGPoint(x: 28.4, y: 24.8),
                   CGPoint(x: 30.0, y: 26.8),
                   CGPoint(x: 30.0, y: 24.4),
                   CGPoint(x: 28.0, y: 22.4),
                   CGPoint(x: 37.6, y: 26.4),
                   CGPoint(x: 39.6, y: 30.4),
                   CGPoint(x: 39.6, y: 26.4),
                   CGPoint(x: 38.4, y: 23.6),
                   CGPoint(x: 36.8, y: 22.0),
                   CGPoint(x: 42.0, y: 23.2),
                   CGPoint(x: 48.0, y: 25.6),
                   CGPoint(x: 46.0, y: 23.4),
                   CGPoint(x: 42.8, y: 20.4),
                   CGPoint(x: 40.8, y: 20.0),
                   CGPoint(x: 44.0, y: 19.6),
                   CGPoint(x: 48.8, y: 19.6),
                   CGPoint(x: 46.8, y: 17.2),
                   CGPoint(x: 42.8, y: 16.4),
                   CGPoint(x: 47.6, y: 15.2),
                   CGPoint(x: 45.2, y: 13.6),
                   CGPoint(x: 41.2, y: 13.6),
                   CGPoint(x: 44.8, y: 12.0),
                   CGPoint(x: 42.0, y: 10.8),
                   CGPoint(x: 39.2, y: 10.8),
                   CGPoint(x: 41.2, y: 9.2),
                   CGPoint(x: 38.4, y: 8.8),
                   CGPoint(x: 35.6, y: 9.2),
                   CGPoint(x: 37.6, y: 7.6),
                   CGPoint(x: 34.0, y: 7.2),
                   CGPoint(x: 35.2, y: 6.0),
                   CGPoint(x: 31.0, y: 6.4),
                   CGPoint(x: 32.4, y: 3.6),
                   CGPoint(x: 28.4, y: 4.4),
                   CGPoint(x: 29.2, y: 2.4),
                   CGPoint(x: 25.2, y: 3.6),
                   CGPoint(x: 26.0, y: 1.6),
                   CGPoint(x: 23.2, y: 2.8),
                   CGPoint(x: 23.6, y: 0.4),
                   CGPoint(x: 20.8, y: 1.6),
                   CGPoint(x: 21.2, y: -0.4),
                   CGPoint(x: 18.4, y: 1.2),
                   CGPoint(x: 18.4, y: -1.2),
                   CGPoint(x: 16.0, y: 0.4),
                   CGPoint(x: 16.4, y: -2.0),
                   CGPoint(x: 13.6, y: -0.4),
                   CGPoint(x: 12.8, y: 1.2),
                   CGPoint(x: 12.8, y: -1.6),
                   CGPoint(x: 10.8, y: 0.0),
                   CGPoint(x: 10.4, y: 1.2),
                   CGPoint(x: 10.0, y: -1.2),
                   CGPoint(x: 8.8, y: -0.4),
                   CGPoint(x: 8.4, y: 0.8),
                   CGPoint(x: 7.6, y: -1.2),
                   CGPoint(x: 7.2, y: -4.0),
                   CGPoint(x: 12.8, y: -6.8),
                   CGPoint(x: 17.2, y: -7.2),
                   CGPoint(x: 16.0, y: -9.6),
                   CGPoint(x: 14.0, y: -10.0),
                   CGPoint(x: 15.2, y: -10.8),
                   CGPoint(x: 13.6, y: -12.4),
                   CGPoint(x: 10.4, y: -12.8),
                   CGPoint(x: 12.8, y: -13.6),
                   CGPoint(x: 10.4, y: -15.6),
                   CGPoint(x: 7.6, y: -15.2),
                   CGPoint(x: 9.2, y: -16.8),
                   CGPoint(x: 6.4, y: -18.0),
                   CGPoint(x: 3.6, y: -17.6),
                   CGPoint(x: 4.8, y: -19.6),
                   CGPoint(x: 2.8, y: -19.6)
                ],
                
                [
                    CGPoint(x: -2.4, y: 9.2),
                    CGPoint(x: -2.4, y: 8),
                    CGPoint(x: -1.6, y: 7.2),
                    CGPoint(x: -1.2, y: 8)
                ],
                [
                    CGPoint(x: 1.2, y: 8),
                    CGPoint(x: 1.6, y: 7.2),
                    CGPoint(x: 2.4, y: 8),
                    CGPoint(x: 2.4, y: 9.2)
                ],
                [
                    CGPoint(x: 0, y: 8.0),
                    CGPoint(x: -0.8, y: 7.6),
                    CGPoint(x: -1.2, y: 6.8),
                    CGPoint(x: -1.6, y: 6.4),
                    CGPoint(x: -3.2, y: 6.4),
                    CGPoint(x: -1.6, y: 5.6),
                    CGPoint(x: -0.8, y: 4.8),
                    CGPoint(x: 0, y: 2.8),
                    CGPoint(x: 0.8, y: 4.8),
                    CGPoint(x: 1.6, y: 5.6),
                    CGPoint(x: 3.2, y: 6.4),
                    CGPoint(x: 1.6, y: 6.4),
                    CGPoint(x: 1.2, y: 6.8),
                    CGPoint(x: 0.8, y: 7.6),
                ],
            ])
        ),
        .init(
            name: "Donut",
            shape: CGShape(paths: TriangleTestStore.circle(count: 16, radius: 4, k: 0.03))
        ),
        .init(
            name: "Chease 1",
            shape: CGShape(paths: [
                [
                    CGPoint(x:   0, y:  20),
                    CGPoint(x:   8, y:  10),
                    CGPoint(x:   7, y:   6),
                    CGPoint(x:   9, y:   1),
                    CGPoint(x:  13, y:  -1),
                    CGPoint(x:  17, y:   1),
                    CGPoint(x:  26, y:  -7),
                    CGPoint(x:  14, y: -15),
                    CGPoint(x:   0, y: -18),
                    CGPoint(x: -14, y: -15),
                    CGPoint(x: -25, y:  -7),
                    CGPoint(x: -18, y:   0),
                    CGPoint(x: -16, y:  -3),
                    CGPoint(x: -13, y:  -4),
                    CGPoint(x:  -8, y:  -2),
                    CGPoint(x:  -6, y:   2),
                    CGPoint(x:  -7, y:   6),
                    CGPoint(x: -10, y:   8)
                ]
            ])
        ),
        .init(
            name: "Chease 2",
            shape: CGShape(paths: [
                [
                    CGPoint(x:   0, y:  20),
                    CGPoint(x:   8, y:  10),
                    CGPoint(x:   7, y:   6),
                    CGPoint(x:   9, y:   1),
                    CGPoint(x:  13, y:  -1),
                    CGPoint(x:  17, y:   1),
                    CGPoint(x:  26, y:  -7),
                    CGPoint(x:  14, y: -15),
                    CGPoint(x:   0, y: -18),
                    CGPoint(x: -14, y: -15),
                    CGPoint(x: -25, y:  -7),
                    CGPoint(x: -18, y:   0),
                    CGPoint(x: -16, y:  -3),
                    CGPoint(x: -13, y:  -4),
                    CGPoint(x:  -8, y:  -2),
                    CGPoint(x:  -6, y:   2),
                    CGPoint(x:  -7, y:   6),
                    CGPoint(x: -10, y:   8)
                ],
                [
                    CGPoint(x:  2, y:   0),
                    CGPoint(x: -2, y:  -2),
                    CGPoint(x: -4, y:  -5),
                    CGPoint(x: -2, y:  -9),
                    CGPoint(x:  2, y: -11),
                    CGPoint(x:  5, y:  -9),
                    CGPoint(x:  7, y:  -5),
                    CGPoint(x:  5, y:  -2)
                ]
            ])
        ),
    ]

    private static func star(count: Int, radius: CGFloat, k: CGFloat) -> [[CGPoint]] {
        let n = CGFloat(count)
        
        let da0 = 2 * CGFloat.pi / n
        let da1 = 16 * CGFloat.pi / n
        let delta = k * radius
        
        var hull = [CGPoint](repeating: .zero, count: count)
        
        var a0: CGFloat = 0
        var a1: CGFloat = 0
        
        
        for i in 0..<count {
            let r = radius + delta * sin(a1)
            let x = r * cos(a0)
            let y = r * sin(a0)
            a0 -= da0
            a1 -= da1
            hull[i] = CGPoint(x: x, y: y)
        }
        
        var hole = [CGPoint](repeating: .zero, count: count)
        
        for i in 0..<count {
            
            let p = hull[count - i - 1]
            hole[i] = CGPoint(x: 0.5 * p.x, y: 0.5 * p.y)
            
        }
        return [hull, hole]
    }
    
    private static func circle(count: Int, radius: CGFloat, k: CGFloat) -> [[CGPoint]] {
        let n = CGFloat(count)
        
        let da0 = 2 * CGFloat.pi / n
        let delta = k * radius
        
        var hull = [CGPoint](repeating: .zero, count: count)
        
        var a0: CGFloat = 0
        let r = radius + delta

        for i in 0..<count {
            
            let x = r * cos(a0)
            let y = r * sin(a0)
            a0 -= da0
            hull[i] = CGPoint(x: x, y: y)
        }
        
        var hole = [CGPoint](repeating: .zero, count: count)
        
        for i in 0..<count {
            let p = hull[count - i - 1]
            hole[i] = CGPoint(x: 0.5 * p.x, y: 0.5 * p.y)
            
        }
        return [hull, hole]
    }
    
}
