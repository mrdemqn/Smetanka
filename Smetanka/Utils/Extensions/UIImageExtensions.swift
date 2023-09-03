//
//  UIImageExtensions.swift
//  Smetanka
//
//  Created by Димон on 13.08.23.
//

import Foundation
import Alamofire
import AlamofireImage
import UIKit

extension UIImageView {
    
    func load(from url: String) {
        image = UIImage(systemName: "fork.knife.circle.fill")
        
        guard let url = URL(string: url) else { return }
        
        let request = URLRequest(url: url)
        
        let imageDownloader = ImageDownloader()
        
        imageDownloader.download(request, completion:  { [weak self] response in
            
            guard response.error == nil else { return }
            
            let result = response.result
            
            switch result {
                case .success(let image):
                    self?.image = image
                default: return
            }
        })
    }
}

extension UIImage {
    
    static let radioSelected = UIImage(imageLiteralResourceName: "radio_selected")
    static let radioUnselected = UIImage(imageLiteralResourceName: "radio_unselected")
}
