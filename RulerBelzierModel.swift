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
    var angle:CGFloat
    var leftPoint:CGPoint
    var rightPoint:CGPoint
    var unitValue:Float
    var upperPointOfLeftStraightLine:CGPoint
    var lowerPointOfLeftStraightLine:CGPoint
    var upperPointOfRightStraightLine:CGPoint
    var lowerPointOfRightStraightLine:CGPoint
    
    var leftButton:modifiedButton
    var rightButton:modifiedButton
    var unitButton:modifiedButton
    
    var midPath:CAShapeLayer
    var leftPath:CAShapeLayer
    var rightPath:CAShapeLayer
    init(ID:Int,leftPoint:CGPoint, rightPoint:CGPoint,midPath:CAShapeLayer,leftPath:CAShapeLayer,rightPath:CAShapeLayer, upPointLeft:CGPoint, lowPointLeft:CGPoint, upPointRight:CGPoint, lowPointRight:CGPoint,leftButton :modifiedButton, rightButton:modifiedButton, angle:CGFloat, unitValue:Float, unitButton:modifiedButton) {
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
        self.leftButton = leftButton
        self.rightButton = rightButton
        self.angle = angle
        self.unitValue = unitValue
        self.unitButton = unitButton
    }
    func removePath(){
        self.midPath.removeFromSuperlayer()
        self.leftPath.removeFromSuperlayer()
        self.rightPath.removeFromSuperlayer()
        print("removed ruler ID \(ID):\(self.midPath)")
    }
    func removeButton(){
        self.unitButton.removeFromSuperview()
    }
   
}
