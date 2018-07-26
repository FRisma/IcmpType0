//
//  ITUtils.swift
//  IcmpType0
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit


let kITLang = "lang"

extension UIColor {
    convenience init(_ hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIView {
    func shake(view: UIView) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        animation.duration = 0.4
        animation.isAdditive = true
        
        view.layer.add(animation, forKey: "shake")
    }
}

class GradientColors {
    var layer:CAGradientLayer!
    
    init(withTopColor topC: UIColor, bottomColor bottomC: UIColor) {
        layer = CAGradientLayer()
        layer.colors = [topC.cgColor, bottomC.cgColor]
        layer.locations = [0.0, 1.0]
    }
}
