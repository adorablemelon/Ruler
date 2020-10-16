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
    let leftBubble:UIButton = UIButton()
    let rightBubble:UIButton = UIButton()
    let rightVerticalLine:UIButton = UIButton()
    let leftVerticalLine:UIButton = UIButton()

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
        pathButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pathButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        pathButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        pathButton.heightAnchor.constraint(equalToConstant: 5).isActive = true
        pathButton.backgroundColor = .red
        pathButton.addGestureRecognizer(panMoveRecognizer)

        
        
        self.addSubview(leftBubble)
        leftBubble.translatesAutoresizingMaskIntoConstraints = false
        leftBubble.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        leftBubble.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        leftBubble.centerXAnchor.constraint(equalTo: pathButton.leadingAnchor).isActive = true
        leftBubble.widthAnchor.constraint(equalToConstant: 30).isActive = true
        leftBubble.clipsToBounds = true
        leftBubble.backgroundColor = .red
        leftBubble.layer.cornerRadius = 30/2
        leftBubble.alpha = 0.3
        
        
        self.addSubview(rightBubble)
        rightBubble.translatesAutoresizingMaskIntoConstraints = false
        rightBubble.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        rightBubble.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        rightBubble.centerXAnchor.constraint(equalTo: pathButton.trailingAnchor).isActive = true
        rightBubble.widthAnchor.constraint(equalToConstant: 30).isActive = true
        rightBubble.clipsToBounds = true
        rightBubble.backgroundColor = .red
        rightBubble.layer.cornerRadius = 30/2
        rightBubble.alpha = 0.3
        rightBubble.addGestureRecognizer(panStretchRecognizer)

        
        

        self.addSubview(rightVerticalLine)
        rightVerticalLine.translatesAutoresizingMaskIntoConstraints = false
        rightVerticalLine.topAnchor.constraint(equalTo: rightBubble.topAnchor, constant: 2).isActive = true
        rightVerticalLine.bottomAnchor.constraint(equalTo: rightBubble.bottomAnchor, constant: -2).isActive = true
        rightVerticalLine.centerXAnchor.constraint(equalTo: pathButton.trailingAnchor).isActive = true
        rightVerticalLine.widthAnchor.constraint(equalToConstant: 5).isActive = true
        rightVerticalLine.backgroundColor = .red
        
        self.addSubview(leftVerticalLine)
        leftVerticalLine.translatesAutoresizingMaskIntoConstraints = false
        leftVerticalLine.topAnchor.constraint(equalTo: leftBubble.topAnchor, constant: 2).isActive = true
        leftVerticalLine.bottomAnchor.constraint(equalTo: leftBubble.bottomAnchor, constant: -2).isActive = true
        leftVerticalLine.centerXAnchor.constraint(equalTo: pathButton.leadingAnchor).isActive = true
        leftVerticalLine.widthAnchor.constraint(equalToConstant: 5).isActive = true
        leftVerticalLine.backgroundColor = .red

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
        if panStretchRecognizer.state == .began{
            notDraggedPoint = recognizer.location(in: self)
        }
        
        if panStretchRecognizer.state == .changed{

            let angle = atan2(touchPoint.y - leftBubble.frame.origin.y, touchPoint.x - leftBubble.frame.origin.x)
            print(angle)
            let center = CGPoint(x: leftBubble.frame.origin.x, y: leftBubble.frame.origin.y)
           
            self.transform = CGAffineTransform(rotationAngle: angle)

        }
    }
}
