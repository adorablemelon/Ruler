//
//  RulerBelzierModel.swift
//  test
//
//  Created by Bao Le on 10/21/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import Foundation
import UIKit
struct RulerBelzierModel {
    var ID:Int
    var leftPoint:CGPoint
    var rightPoint:CGPoint
    var upperPointOfLeftStraightLine:CGPoint
    var lowerPointOfLeftStraightLine:CGPoint
    var upperPointOfRightStraightLine:CGPoint
    var lowerPointOfRightStraightLine:CGPoint
    var midPath:CAShapeLayer
    var leftPath:CAShapeLayer
    var rightPath:CAShapeLayer
    init(ID:Int,leftPoint:CGPoint, rightPoint:CGPoint,midPath:CAShapeLayer,leftPath:CAShapeLayer,rightPath:CAShapeLayer, upPointLeft:CGPoint, lowPointLeft:CGPoint, upPointRight:CGPoint, lowPointRight:CGPoint) {
        self.ID = ID
        self.leftPoint = leftPoint
        self.rightPoint = rightPoint
        self.midPath = midPath
        self.leftPath = leftPath
        self.rightPath = rightPath
        self.upperPointOfLeftStraightLine = upPointLeft
        self.lowerPointOfLeftStraightLine = lowPointLeft
        self.upperPointOfRightStraightLine = upPointRight
        self.lowerPointOfRightStraightLine = lowPointRight
    }
    func removePath(){
        self.midPath.removeFromSuperlayer()
        self.leftPath.removeFromSuperlayer()
        self.rightPath.removeFromSuperlayer()
        print("removed ruler ID \(ID):\(self.midPath)")
    }
}
