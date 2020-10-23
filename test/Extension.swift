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
    func differPoint(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGPoint(x: xDist, y: yDist)
    }
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
    
    func setAnchorPoint(_ point: CGPoint) {
            var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
            var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

            newPoint = newPoint.applying(transform)
            oldPoint = oldPoint.applying(transform)

            var position = layer.position

            position.x -= oldPoint.x
            position.x += newPoint.x

            position.y -= oldPoint.y
            position.y += newPoint.y

            layer.position = position
            layer.anchorPoint = point
        }
   

    
    
}
extension CGAffineTransform {
    var angle: CGFloat { return atan2(-self.c, self.a) }

    var angleInDegrees: CGFloat { return self.angle * 180 / .pi }

    var scaleX: CGFloat {
        let angle = self.angle
        return self.a * cos(angle) - self.c * sin(angle)
    }

    var scaleY: CGFloat {
        let angle = self.angle
        return self.d * cos(angle) + self.b * sin(angle)
    }
}

extension CGPoint{
   
}

