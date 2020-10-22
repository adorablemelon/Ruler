//
//  modifiedButton.swift
//  test
//
//  Created by Bao Le on 10/22/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import UIKit

class modifiedButton: UIButton {
    enum positionEnum{
        case left
        case right
        case middle
    }
    var position:positionEnum

    init(position: positionEnum) {
        self.position = position
        super.init(frame: .zero)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    

    

