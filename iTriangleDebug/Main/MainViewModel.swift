//
//  MainViewModel.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

import SwiftUI
import iDebug

final class MainViewModel: ObservableObject {

    private let monotoneScene = MonotoneScene(id: 0)
    private let delaunayScene = DelaunayScene(id: 1)
    private var testStore: TestStore?

    private (set) var pIndex = PersistInt(key: "TestIndex", nilValue: 0)
    
    lazy var scenes: [SceneHandler] = [
        monotoneScene.handler,
        delaunayScene.handler
    ]

    @Published
    var sceneId: Int = 0 {
        didSet {
            self.update(id: sceneId)
        }
    }
    
    @Published
    var testId: Int = 0 {
        didSet {
            testStore?.testId = testId
        }
    }
    
    @Published
    var tests: [TestHandler] = []
    
    @ViewBuilder var sceneView: some View {
        switch sceneId {
        case 0:
            monotoneScene.makeView()
        case 1:
            delaunayScene.makeView()
        default:
            fatalError("scene not set")
        }
    }
    
    func onAppear() {
        sceneId = pIndex.value
    }
    
    private func update(id: Int) {
        if sceneId != id {
            sceneId = id
        }
        
        if pIndex.value != id {
            pIndex.value = id
        }
        
        switch id {
        case 0:
            testStore = monotoneScene.testStore
        case 1:
            testStore = delaunayScene.testStore
        default:
            break
        }
        
        tests = testStore?.tests ?? []
    }
}
