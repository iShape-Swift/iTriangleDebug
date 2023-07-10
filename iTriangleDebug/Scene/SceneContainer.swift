//
//  SceneContainer.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

struct SceneHandler: Identifiable {
    
    let id: Int
    let title: String
}

protocol SceneContainer {

    var id: Int { get }
    var title: String { get }
    var testStore: TestStore { get }
}

extension SceneContainer {
    
    var handler: SceneHandler {
        SceneHandler(id: id, title: title)
    }
    
}
