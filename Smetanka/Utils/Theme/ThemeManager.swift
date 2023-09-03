//
//  ThemeManager.swift
//  Smetanka
//
//  Created by Димон on 8.08.23.
//

import UIKit

final class ThemeManager {
    
    static func switchTheme() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

        DispatchQueue.main.async {
            UIView.transition(with: UIView(), duration: 0.3, options: .transitionCrossDissolve) {
                scene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                }
            }
        }
    }
    
    static let currentStyle: UIUserInterfaceStyle = UIScreen.main.traitCollection.userInterfaceStyle
}
