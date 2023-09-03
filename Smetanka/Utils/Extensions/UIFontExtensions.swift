//
//  UIFontExtension.swift
//  Smetanka
//
//  Created by Димон on 2.09.23.
//

import UIKit

extension UIFont {
    
    static func helveticaNeueFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: Font.helveticaNeue, size: size) ?? .systemFont(ofSize: size)
    }
}
