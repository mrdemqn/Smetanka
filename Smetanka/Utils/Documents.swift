//
//  Documents.swift
//  Smetanka
//
//  Created by Димон on 2.10.23.
//

import Foundation

class Documents {
    static func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
    
    static func readImage(imagePath: String) -> Data? {
        guard let path = documentDirectoryPath() else { return nil }
        
        let imageURL = path.appendingPathComponent(imagePath)
        
        let pngImage = FileManager.default.contents(atPath: imageURL.path)
        
        print(pngImage ?? "Hello")
        
        return pngImage
    }
}
