//
//  UIButtonExtensions.swift
//  Smetanka
//
//  Created by Димон on 2.09.23.
//

import UIKit

extension UIButton {
    
    func addTopBorder(borderWidth: CGFloat,
                      _ borderColor: UIColor? = .profileBorderButton) {
        let border = CALayer()
        
        border.backgroundColor = borderColor?.cgColor
        border.frame = CGRect(x: 0.0,
                              y: 0.0,
                              width: frame.size.width,
                              height: borderWidth)
        
        layer.addSublayer(border)
    }
    
    func addBottomBorder(borderWidth: CGFloat,
                         _ borderColor: UIColor? = .profileBorderButton) {
        let border = CALayer()
        
        border.backgroundColor = borderColor?.cgColor
        border.frame = CGRect(x: 0,
                              y: frame.size.height - borderWidth,
                              width: frame.size.width,
                              height: borderWidth)
        layer.addSublayer(border)
    }
    
    func addVerticalBorder(borderWidth: CGFloat,
                           _ borderColor: UIColor? = .profileBorderButton) {
        addTopBorder(borderWidth: borderWidth, borderColor)
        addBottomBorder(borderWidth: borderWidth, borderColor)
    }
}
