//
//  DrawingUIView.swift
//  test
//
//  Created by Bao Le on 10/16/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import UIKit

class DrawingUIView: UIView {
    
    var rulerViewWidth:CGFloat = 200
    var rulerViewHeight:CGFloat = 60
    var startPosition:CGPoint = .zero
    var originalHeight:CGFloat = 0
    var rulerViewArray = [RulerUIView]()
    var currentUsingRulerView:UIView = UIView()
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
    }()
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
    }()
    
    required init() {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapRecognizer)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func handlePan(recognizer: UIPanGestureRecognizer){
        let touchPoint = recognizer.location(in: self)
        
    }
    @objc func handleTap(recognizer: UIGestureRecognizer) {
        let touchPoint = recognizer.location(in: self)
        let rulerView:RulerUIView = RulerUIView()
        rulerView.frame = CGRect(x: touchPoint.x - rulerViewWidth/2, y: touchPoint.y - rulerViewHeight/2, width: rulerViewWidth, height: rulerViewHeight)
        self.addSubview(rulerView)
        rulerViewArray.append(rulerView)
    }

}
