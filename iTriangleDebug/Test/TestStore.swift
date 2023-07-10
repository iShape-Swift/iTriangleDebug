//
//  TestStore.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 10.07.2023.
//

struct TestHandler: Identifiable {
    
    let id: Int
    let title: String
}

protocol TestStore {
    
    var tests: [TestHandler] { get }
    var testId: Int { get set }
    
}
