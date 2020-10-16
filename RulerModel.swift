//
//  RulerModel.swift
//  test
//
//  Created by Bao Le on 10/15/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import Foundation
import UIKit
struct RulerStruct{
    static var key:Int = 0
    var angle:CGFloat
    var startPoint:CGPoint?
    var endPoint:CGPoint?
    var dotStartPointX:CGPoint?
    var dotStartPointY:CGPoint?
    var dotEndPointX:CGPoint?
    var dotEndPointY:CGPoint?
    var path:CAShapeLayer?
    var dotStart:CAShapeLayer?
    var dotEnd:CAShapeLayer?
    var circleStart:CAShapeLayer?
    var circleEnd:CAShapeLayer?
    var arrayShapeLayer:[CAShapeLayer] = [CAShapeLayer]()
    var tag:Int?
    init(startPoint:CGPoint, endPoint:CGPoint, dotStartPointX:CGPoint, dotStartPointY:CGPoint, dotEndPointX:CGPoint, dotEndPointY:CGPoint, path:CAShapeLayer, dotStart:CAShapeLayer, dotEnd:CAShapeLayer, circleStart:CAShapeLayer, circleEnd:CAShapeLayer, angle:CGFloat) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.dotEndPointY = dotEndPointY
        self.dotEndPointX = dotEndPointX
        self.dotStartPointY = dotEndPointY
        self.dotStartPointX = dotEndPointX
        self.path = path
        self.dotStart = dotStart
        self.dotEnd = dotEnd
        self.circleEnd = circleEnd
        self.circleStart = circleStart
        self.angle = angle
        self.tag = RulerStruct.key
        RulerStruct.key += 1
        arrayShapeLayer.append(contentsOf: [path,dotEnd,dotStart,circleStart,circleEnd])
        
    }
 
    func deleteRuler(){
        self.path?.removeFromSuperlayer()
        self.dotStart?.removeFromSuperlayer()
        self.dotEnd?.removeFromSuperlayer()
        self.circleStart?.removeFromSuperlayer()
        self.circleEnd?.removeFromSuperlayer()
        
    }
}
