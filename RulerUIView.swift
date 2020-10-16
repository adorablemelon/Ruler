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
    var currentTag = 0
    var rulerViewTag:Int?
    var differenceX: CGFloat!
    var differenceY: CGFloat!


    var notDraggedPoint:CGPoint = .zero
    required init() {
        print("init")
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        self.backgroundColor = .yellow
        self.autoresizesSubviews = true
        self.viewWithTag(currentTag)
        rulerViewTag = currentTag
        currentTag += 1
        drawRulerInside()
        //self.addGestureRecognizer(panRecognizer)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawRulerInside(){
        let pathButton:UIButton = UIButton()
        self.addSubview(pathButton)
        pathButton.translatesAutoresizingMaskIntoConstraints = false
        pathButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        pathButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        pathButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        pathButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        pathButton.backgroundColor = .red
        pathButton.addGestureRecognizer(panMoveRecognizer)

        
        let leftVerticalLine:UIButton = UIButton()
        self.addSubview(leftVerticalLine)
        leftVerticalLine.translatesAutoresizingMaskIntoConstraints = false
        leftVerticalLine.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        leftVerticalLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        leftVerticalLine.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5).isActive = true
        leftVerticalLine.trailingAnchor.constraint(equalTo: pathButton.leadingAnchor).isActive = true
        leftVerticalLine.backgroundColor = .red
        
        let rightVerticalLine:UIButton = UIButton()
        self.addSubview(rightVerticalLine)
        rightVerticalLine.translatesAutoresizingMaskIntoConstraints = false
        rightVerticalLine.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        rightVerticalLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        rightVerticalLine.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5).isActive = true
        rightVerticalLine.leadingAnchor.constraint(equalTo: pathButton.trailingAnchor).isActive = true
        rightVerticalLine.backgroundColor = .red
    }
    
    private lazy var panMoveRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(handlePanMove(recognizer:)))
    }()
    private lazy var panStretchRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(handlePanStretch(recognizer:)))
    }()
    
    @objc func handlePanMove(recognizer: UIPanGestureRecognizer){
        let touchPoint = recognizer.location(in: self)
        if panMoveRecognizer.state == .began{
            print(notDraggedPoint = recognizer.location(in: self))
        }
        if panMoveRecognizer.state == .changed{
            differenceX = touchPoint.x - notDraggedPoint.x
            differenceY = touchPoint.y - notDraggedPoint.y
            var newFrame = self.frame
            newFrame.origin.x = self.frame.origin.x + differenceX
            newFrame.origin.y = self.frame.origin.y + differenceY
            self.frame = newFrame
        }
    }
    
    @objc func handlePanStretch(recognizer: UIPanGestureRecognizer){
        let touchPoint = recognizer.location(in: self)
        if panMoveRecognizer.state == .began{
            print(notDraggedPoint = recognizer.location(in: self))
        }
        if panMoveRecognizer.state == .changed{
            differenceX = touchPoint.x - notDraggedPoint.x
            differenceY = touchPoint.y - notDraggedPoint.y
            var newFrame = self.frame
            newFrame.origin.x = self.frame.origin.x + differenceX
            newFrame.origin.y = self.frame.origin.y + differenceY
            self.frame = newFrame
        }
    }
}
