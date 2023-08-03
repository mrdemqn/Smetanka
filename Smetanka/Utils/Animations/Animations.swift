//
//  Animations.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import UIKit

protocol AnimationsProtocol {
    
    func bezierHoleIntoView(_ view: UIView?)
}

final class Animations: AnimationsProtocol {
    
    private let layer = CAShapeLayer()
    
    func bezierHoleIntoView(_ view: UIView?) {
        guard let view = view else { return }
        
        let center = view.convert(view.center, from: view)
        let globalSize = view.frame.size
        
        let size1 = CGSize(width: 0.1, height: 0.1)
        let size2 = CGSize(width: globalSize.width, height: globalSize.height)
        
        let x1 = center.x - (size1.width / 2)
        let x2 = center.x - (size2.width / 2)
        
        let y1 = center.y - (size1.height / 2)
        let y2 = center.y - (size2.height / 2)
        
        let point1 = CGPoint(x: x1, y: y1)
        let point2 = CGPoint(x: x2, y: y2)
        
        let rectFrame1 = CGRect(origin: point1, size: size1)
        
        let rectFrame2 = CGRect(origin: point2, size: size2)
        
        let path = UIBezierPath(roundedRect: rectFrame1, cornerRadius: 50)
        let path2 = UIBezierPath(roundedRect: rectFrame2, cornerRadius: 50)
        
        path.append(UIBezierPath(rect: view.bounds))
        path2.append(UIBezierPath(rect: view.bounds))
        
        layer.fillRule = CAShapeLayerFillRule.evenOdd
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.path = path.cgPath
        CATransaction.commit()
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = path.cgPath
        animation.toValue = path2.cgPath
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: nil)
        
        view.layer.mask = layer
    }
}
