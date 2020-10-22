//
//  modifiedCAShapeLayer.swift
//  test
//
//  Created by Bao Le on 10/22/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import UIKit

class modifiedCAShapeLayer: CAShapeLayer {
    var tag:Int = 0

    required init?(coder aDecoder: NSCoder, tag:Int) {
        self.tag = tag
        super.init(coder: aDecoder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
