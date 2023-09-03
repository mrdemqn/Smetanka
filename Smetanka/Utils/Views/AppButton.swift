//
//  AppButton.swift
//  Smetanka
//
//  Created by Димон on 3.09.23.
//

import UIKit

final class AppButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
                UIView.animate(withDuration: 0.3) { [unowned self] in
                    backgroundColor = .buttonHighLighted
                    setTitleColor(.generalText, for: .highlighted)
                }
            }
            else {
                UIView.animate(withDuration: 0.3, delay: 0.2) { [unowned self] in
                    backgroundColor = .clear
                }
            }
            super.isHighlighted = newValue
        }
    }

}
