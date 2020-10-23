//
//  modifedUIView.swift
//  test
//
//  Created by Bao Le on 10/23/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import UIKit

class modifedUIView: UIView {
    var tagUIView = 0
    
    required init(tag:Int, frame:CGRect) {
        self.tagUIView = tag
        super.init(frame: .zero)
        self.frame = frame
        self.backgroundColor = .yellow
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
