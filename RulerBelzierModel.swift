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
    var midPath:CAShapeLayer
    var leftPath:CAShapeLayer
    var rightPath:CAShapeLayer
    init(ID:Int,leftPoint:CGPoint, rightPoint:CGPoint,midPath:CAShapeLayer,leftPath:CAShapeLayer,rightPath:CAShapeLayer) {
        self.ID = ID
        self.leftPoint = leftPoint
        self.rightPoint = rightPoint
        self.midPath = midPath
        self.leftPath = leftPath
        self.rightPath = rightPath
    }
}
