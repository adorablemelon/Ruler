//
//  DrawingUIViewByBelzier.swift
//  test
//
//  Created by Bao Le on 10/21/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import UIKit

class DrawingUIViewByBelzier: UIView {
    var globalTag = 0
    var rulerViewWidth:CGFloat = 200
    var rulerViewHeight:CGFloat = 60
    var startPosition:CGPoint = .zero
    var originalHeight:CGFloat = 0
    var RulerModelArray = [RulerBelzierModel]()
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
    }()
    
   
    
    required init() {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapRecognizer)
        self.backgroundColor = .blue
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func handleTap(recognizer: UIGestureRecognizer) {
        let touchPoint = recognizer.location(in: self)
        drawRuler(midPoint: touchPoint)
    }
    
    @objc func handleButtonLongPress(recognizer: UIGestureRecognizer) {
        let touchPoint = recognizer.location(in: self)
        guard let button = recognizer.view as? UIButton else { return }
        let rulerID = button.tag
        

    }
    
//    func returnAllThePath(ID:Int)->[CAShapeLayer]{
////        var arr = [CAShapeLayer]()
////        for each in RulerModelArray{
////            if each.ID == ID
////            {
////                
////            }
////        }
//    }
    
    func drawRuler(midPoint:CGPoint){
        let rulerTag = globalTag
        let rightPoint = CGPoint(x: midPoint.x + rulerViewWidth/2, y: midPoint.y)
        let leftPoint = CGPoint(x: midPoint.x - rulerViewWidth/2, y: midPoint.y)
        let upperPointOfLeftStraightLine = CGPoint(x: leftPoint.x, y: leftPoint.y + 10)
        let lowerPointOfLeftStraightLine = CGPoint(x: leftPoint.x, y: leftPoint.y - 10)
        let upperPointOfRightStraightLine = CGPoint(x: rightPoint.x, y: rightPoint.y + 10)
        let lowerPointOfRightStraightLine = CGPoint(x: rightPoint.x, y: rightPoint.y - 10)
        
        let leftButton = UIButton(frame: CGRect(x: leftPoint.x - 15, y: rightPoint.y - 15, width: 30, height: 30))
        self.addSubview(leftButton)
        leftButton.clipsToBounds = true
        leftButton.backgroundColor = .red
        leftButton.layer.cornerRadius = 30/2
        leftButton.alpha = 0.3
        leftButton.layer.cornerRadius = 30/2
        leftButton.tag = rulerTag
        let leftButtonTapRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleButtonLongPress(recognizer:)))
        leftButton.addGestureRecognizer(leftButtonTapRecognizer)
        
        let rightButton = UIButton(frame: CGRect(x: rightPoint.x - 15, y: leftPoint.y - 15, width: 30, height: 30))
        self.addSubview(rightButton)
        rightButton.clipsToBounds = true
        rightButton.backgroundColor = .red
        rightButton.layer.cornerRadius = 30/2
        rightButton.alpha = 0.3
        rightButton.layer.cornerRadius = 30/2
        rightButton.tag = rulerTag
        let rightButtonTapRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleButtonLongPress(recognizer:)))
        rightButton.addGestureRecognizer(rightButtonTapRecognizer)
        globalTag += 1
        
        let midPath = drawALine(point1: leftPoint, point2: rightPoint)
        let leftPath = drawALine(point1: upperPointOfLeftStraightLine, point2: lowerPointOfLeftStraightLine)
        let rightPath = drawALine(point1: upperPointOfRightStraightLine, point2: lowerPointOfRightStraightLine)
        
        let rulerModel = RulerBelzierModel(ID: rulerTag, leftPoint: leftPoint, rightPoint: rightPoint, midPath: midPath, leftPath: leftPath, rightPath: rightPath)
        RulerModelArray.append(rulerModel)
        
    }
    
    func drawALine(point1:CGPoint,point2:CGPoint)->CAShapeLayer{
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 5
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }
    
    
}
