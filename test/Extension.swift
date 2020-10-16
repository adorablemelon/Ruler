//
//  File.swift
//  test
//
//  Created by Bao Le on 10/6/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import Foundation
import UIKit
extension CAShapeLayer {
    func rotate(degrees: CGFloat) {
        rotatee(radians: CGFloat.pi * degrees / 180.0)
    }
    
    func rotatee(radians: CGFloat) {
        self.setAffineTransform(CGAffineTransform(rotationAngle: radians))
    }
}

extension UIBezierPath {
    func rotate(path:UIBezierPath, angle:CGFloat){
        let bounds:CGRect = path.cgPath.boundingBox
        let center:CGPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        //let radians:CGFloat = (degree/180 * .pi)
        var transform:CGAffineTransform = CGAffineTransform.identity
        transform = transform.translatedBy(x: center.x, y: center.y);
        transform = transform.rotated(by: angle);
        transform = transform.translatedBy(x: -center.x, y: -center.y);
        path.apply(transform)
    }
    
}
extension UIView{
    func distanceFromTwoPoints(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    func middlePoint(_ a: CGPoint, _ b: CGPoint) -> CGPoint{
        var middle:CGPoint = .zero
        middle.x = (a.x + b.x) / 2
        middle.y = (a.y + b.y) / 2
        return middle
    }
    
    func overlapHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {

            // 1
            if !self.isUserInteractionEnabled || self.isHidden || self.alpha == 0 {

                return nil
            }

            // 2
            var hitView: UIView? = self
            if !self.point(inside: point, with: event) {

                if self.clipsToBounds {

                    return nil
                } else {

                    hitView = nil
                }
            }

            // 3
            for subview in self.subviews.reversed() {

                let insideSubview = self.convert(point, to: subview)
                if let sview = subview.overlapHitTest(point: insideSubview, withEvent: event) {
                    return sview
                }
            }
            return hitView
        }
    
}
extension CGRect{
    var center: CGPoint { return CGPoint(x: midX, y: midY) }

}


