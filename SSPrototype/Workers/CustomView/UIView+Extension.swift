//
//  UIView+Extension.swift
//  SSPrototype
//
//  Created by Narong Kanthanu on 30/10/2561 BE.
//  Copyright © 2561 Narong Kanthanu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setGradientBackground(startColor: UIColor, endColor: UIColor, angle: CGFloat) {
        //self.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
        let (start, end) = gradientPointsForAngle(angle)
        let gradientLayer: CAGradientLayer! = CAGradientLayer()
        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        gradientLayer.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: UIScreen.main.bounds.width, height: 100)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = start
        gradientLayer.endPoint = end
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    private func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    private func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
        let end = pointForAngle(angle)
        let start = oppositePoint(end)
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
        return (p0, p1)
    }
    
    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)
        if (abs(x) > abs(y)) {
            x = x > 0 ? 1 : -1
            y = x * tan(radians)
        } else {
            y = y > 0 ? 1 : -1
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }
    
    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
    
    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }
    
}
