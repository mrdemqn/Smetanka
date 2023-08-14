//
//  UIImageExtensions.swift
//  Smetanka
//
//  Created by Димон on 13.08.23.
//

import Foundation
import Alamofire
import UIKit

extension UIImageView {
    
    func imageFormUrl(_ url: String) {
        image = UIImage(named: "fork.knife.circle.fill")
        AF.request(url).response { [weak self] response in
            guard let data = response.data else { return }
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }
    }
}

final class LazyImageView: UIImageView {
    
    private let imageCache = NSCache<AnyObject, UIImage>()
    
    func loadImage(fromURL imageURL: String)
    {
        self.image = UIImage(named: "fork.knife.circle.fill")

        guard let imageURL = URL(string: imageURL) else { return }
        
        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject)
        {
            
            debugPrint("image loaded from cache for =\(imageURL)")
            self.image = cachedImage
            return
        }

        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: imageURL) {
                debugPrint("image downloaded from server...")
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
}
