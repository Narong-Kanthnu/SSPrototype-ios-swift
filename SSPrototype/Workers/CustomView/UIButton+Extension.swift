//
//  UIButton+Extension.swift
//  SSPrototype
//
//  Created by Narong Kanthanu on 28/10/2561 BE.
//  Copyright © 2561 Narong Kanthanu. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func shakesAnimation() {
        
        let topImage = UIImage(asset: Asset.Button.icShakesButtonTop)
        let pressImage = UIImage(asset: Asset.Button.icShakesButtonPress)
        
        let fromPoint = CGPoint(x: center.x, y: center.y)
        let fronValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 4, y: center.y + 4)
        let toValue = NSValue(cgPoint: toPoint)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.3
        animation.autoreverses = true
        animation.fromValue = fronValue
        animation.toValue = toValue
        
        let crossFade = CABasicAnimation(keyPath: "contents")
        crossFade.duration = 0.3
        crossFade.autoreverses = true
        crossFade.fromValue = topImage?.cgImage
        crossFade.toValue = pressImage?.cgImage
        crossFade.isRemovedOnCompletion = false
        crossFade.fillMode = CAMediaTimingFillMode.forwards
        self.imageView?.layer.add(crossFade, forKey: "animateContents")
        
        layer.add(animation, forKey: nil)
    }
}
