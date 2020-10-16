//
//  RulerUIView.swift
//  test
//
//  Created by Bao Le on 10/15/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import Foundation
import UIKit
class RulerUIView: UIView {
    required init() {
        print("init")
        super.init(frame: .zero)
        //self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .yellow
        self.autoresizesSubviews = true
      
        drawRulerInside()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawRulerInside(){
        let button:UIButton = UIButton()
        self.addSubview(button)
        print(self.frame.width)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        button.backgroundColor = .red
    }
    
}
