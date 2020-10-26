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
    func pToAx(point:CGPoint) -> CGFloat {
        let loc = point
        let c = self.convert(self.center, from:self.superview!)
        return atan2(loc.y - c.y, loc.x - c.x)
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

extension UIBezierPath{
    
    func hasForHorizontalLine(pt point: CGPoint) -> Bool{
        
        let bezierRect = self.bounds
        let origin = bezierRect.origin
        let size = bezierRect.size

        if origin.x <= point.x , origin.x + size.width >= point.x, origin.y - lineWidth * 0.5 <= point.y , origin.y + lineWidth * 0.5 >= point.y{
            return true
        }
        else{
            return false
        }
    }
    
}
extension CGPoint{
    
    // tolerance, should by the lineWidth of a UIBezierPath

    func contained(byStraightLine start: CGPoint,to end: CGPoint, tolerance width: CGFloat) -> Bool{

        return distance(fromLine: start, to: end) <= width * 0.5
    }
    
    
    
    func distance(fromLine start: CGPoint,to end: CGPoint) -> CGFloat{
        
        let a = end.y - start.y
        let b = start.x - end.x
        
        let c = (start.y - end.y) * start.x + ( end.x - start.x ) * start.y
        return abs(a * x + b * y + c)/sqrt(a*a + b*b)
    }
    
}
