//
//  AuthField.swift
//  Smetanka
//
//  Created by Димон on 31.08.23.
//

import Foundation
import UIKit

final class AuthField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    func setupPlaceholder(_ placeholder: String) {
        self.placeholder = placeholder
    }
    
    private func setupTextField() {
        textColor = .fieldText
        
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor.red.cgColor
        
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 10, height: 10)
        
        font = UIFont(name: Font.helveticaNeue, size: 14)
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
