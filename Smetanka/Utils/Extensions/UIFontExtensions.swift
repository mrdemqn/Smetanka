//
//  UIFontExtension.swift
//  Smetanka
//
//  Created by Димон on 2.09.23.
//

import UIKit

extension UIFont {
    
    static func helveticaNeueFont(_ size: CGFloat, weight: Weight = .regular) -> UIFont {
        let descriptor = UIFontDescriptor(name: Font.helveticaNeue, size: size)
        descriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
        let font = UIFont(descriptor: descriptor, size: size)
        return font
    }
}
