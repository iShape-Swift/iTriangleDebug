//
//  TriangulationTestBank.swift
//  iTriangleDebug
//
//  Created by Nail Sharipov on 25.11.2023.
//


import iShape
import iFixFloat
import Foundation
import simd
import iTriangle

struct TriangulationTest: Decodable {
    let scale: Int64
    let shape: FixShape
    enum CodingKeys: String, CodingKey {
        case scale
        case shape
    }
}

extension FixShape: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let paths = try container.decode([FixPath].self, forKey: .paths)
        self.init(paths: paths)
    }
    
    enum CodingKeys: String, CodingKey {
        case paths
    }
}

struct TriangulationTestBank {

    private var folderUrl: URL {
        guard let folderUrl = Bundle.main.resourceURL?.appending(path: "Tests", directoryHint: .isDirectory).appending(path: "Triangulation", directoryHint: .isDirectory) else {
            fatalError("Folder not found.")
        }
        
        return folderUrl
    }
    
    
    func count() -> Int {
        let fileManager = FileManager.default
        do {
            let contents = try fileManager.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: nil, options: [])
            
            // Filter the contents to get only 'json' files
            let jsonFiles = contents.filter { $0.pathExtension == "json" }
            
            // Count the 'json' files
            let jsonFilesCount = jsonFiles.count
            
            return jsonFilesCount
        } catch {
            fatalError("Could not retrieve contents of the folder: \(error)")
        }
    }
    
    func load(index: Int) -> TriangulationTest {
        let folder = self.folderUrl

        let fileName = "triangle_test_\(index).json"
        
        let fileURL = folder.appending(component: fileName, directoryHint: .notDirectory)
        do {
            let data = try Data(contentsOf: fileURL)

            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(TriangulationTest.self, from: data)
            
            return decodedData
        } catch {
            fatalError("Error loading \(fileName): \(error)")
        }
    }
    
    func loadAll() -> [TriangulationTest] {
        var result = [TriangulationTest]()
        let count = self.count()
        result.reserveCapacity(count)
        for i in 0..<count {
            result.append(self.load(index: i))
        }
        
        return result
    }
    
}
