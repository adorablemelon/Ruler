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
    var nailPoint:CGPoint = .zero
    var buttonCenter: CGPoint = .zero
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
    }()
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(recognizer:)))

    }()
   
    
    required init() {
        super.init(frame: .zero)
     
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapRecognizer)
        self.addGestureRecognizer(panRecognizer)
        self.backgroundColor = .blue
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func handleTap(recognizer: UIGestureRecognizer) {
        let touchPoint = recognizer.location(in: self)
        drawRuler(midPoint: touchPoint)
    }
    
    var tempPathCAShapeLayer = CAShapeLayer()
    var tempRightCAShapeLayer = CAShapeLayer()
    var tempLeftCAShapeLayer = CAShapeLayer()
    var isRightButton:Bool = false
    
    @objc func handlePanGesture(recognizer: UIGestureRecognizer){
        let touchPoint = recognizer.location(in: self)
        for each in RulerModelArray{
            print(each.midPath.path!)
            print(touchPoint)
            if each.midPath.path?.boundingBoxOfPath.contains(touchPoint) == true{
                print(each.ID)
            }
        }
    }
    
    @objc func handleButtonLongPress(recognizer: UIGestureRecognizer) {
        let touchPoint = recognizer.location(in: self)
        guard let button = recognizer.view as? modifiedButton else { return }
        let rulerID = button.tag
        RulerModelArray[rulerID].removePath()
        switch recognizer.state {
        case .began:
            button.center = touchPoint
            nailPoint = nonTouchedButtonPosition(ID: rulerID, position: button.position)
            drawTempLine(point1: nailPoint, point2: touchPoint, tempCAShapeLayer: tempPathCAShapeLayer)
            drawTempLine(point1: CGPoint(x: nailPoint.x, y: nailPoint.y + 10), point2: CGPoint(x: nailPoint.x, y: nailPoint.y - 10), tempCAShapeLayer: tempRightCAShapeLayer)
            drawTempLine(point1: CGPoint(x: button.center.x, y: button.center.y + 10), point2: CGPoint(x: button.center.x, y: button.center.y - 10), tempCAShapeLayer: tempLeftCAShapeLayer)
            buttonCenter = button.center

        case .changed:
            button.center = touchPoint
            drawTempLine(point1: nailPoint, point2: touchPoint, tempCAShapeLayer: tempPathCAShapeLayer)
            drawTempLine(point1: CGPoint(x: nailPoint.x, y: nailPoint.y + 10), point2: CGPoint(x: nailPoint.x, y: nailPoint.y - 10), tempCAShapeLayer: tempRightCAShapeLayer)
            drawTempLine(point1: CGPoint(x: button.center.x, y: button.center.y + 10), point2: CGPoint(x: button.center.x, y: button.center.y - 10), tempCAShapeLayer: tempLeftCAShapeLayer)
        case .ended:
            let position = touchedButtonPosition(position: button.position)
            substituteRulerAfterStretch(ID: rulerID, positionOfMovedButton: position, newPosition: touchPoint)
            tempPathCAShapeLayer.removeFromSuperlayer()
        default: print("default")
            break
        }
    }
}

extension DrawingUIViewByBelzier{
    func substituteRulerAfterStretch(ID:Int,positionOfMovedButton:String, newPosition:CGPoint ){
        let newLine = drawALine(point1: nailPoint, point2: newPosition)
        let rightNewLine = drawALine(point1: CGPoint(x: nailPoint.x, y: nailPoint.y + 10), point2: CGPoint(x: nailPoint.x, y: nailPoint.y - 10))
        let leftNewLine = drawALine(point1: CGPoint(x: newPosition.x, y: newPosition.y + 10), point2: CGPoint(x: newPosition.x, y: newPosition.y - 10))
        RulerModelArray[ID].midPath = newLine
        RulerModelArray[ID].leftPath = leftNewLine
        RulerModelArray[ID].rightPath = rightNewLine
        if positionOfMovedButton == "Left"{
            print("left")
            RulerModelArray[ID].leftPoint = newPosition
        }
        if positionOfMovedButton == "Right"{
            print("Right")
            RulerModelArray[ID].rightPoint = newPosition
        }
    }
    

    func nonTouchedButtonPosition(ID:Int, position:modifiedButton.positionEnum)->CGPoint{ // return position of non touched Button
        if position == .left{
            return RulerModelArray[ID].rightPoint
        }else if position == .right{
            return RulerModelArray[ID].leftPoint
        }
        return .zero
    }
    
    func touchedButtonPosition(position:modifiedButton.positionEnum)->String{
        if position == .left{
            isRightButton = false
            return "Left"
        }else if position == .right{
            isRightButton = true
            return "Right"
        }
        return ""
    }

    func drawRuler(midPoint:CGPoint){
        let rulerTag = globalTag
        let rightPoint = CGPoint(x: midPoint.x + rulerViewWidth/2, y: midPoint.y)
        let leftPoint = CGPoint(x: midPoint.x - rulerViewWidth/2, y: midPoint.y)
        let upperPointOfLeftStraightLine = CGPoint(x: leftPoint.x, y: leftPoint.y + 10)
        let lowerPointOfLeftStraightLine = CGPoint(x: leftPoint.x, y: leftPoint.y - 10)
        let upperPointOfRightStraightLine = CGPoint(x: rightPoint.x, y: rightPoint.y + 10)
        let lowerPointOfRightStraightLine = CGPoint(x: rightPoint.x, y: rightPoint.y - 10)
        
        let leftButton = modifiedButton(position: .left)
        leftButton.frame =  CGRect(x: leftPoint.x - 15, y: rightPoint.y - 15, width: 30, height: 30)
        self.addSubview(leftButton)
        leftButton.clipsToBounds = true
        leftButton.backgroundColor = .red
        leftButton.layer.cornerRadius = 30/2
        leftButton.alpha = 0.3
        leftButton.layer.cornerRadius = 30/2
        leftButton.tag = rulerTag
        let leftButtonTapRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleButtonLongPress(recognizer:)))
        leftButton.addGestureRecognizer(leftButtonTapRecognizer)
        
        let rightButton = modifiedButton(position: .right)
        rightButton.frame = CGRect(x: rightPoint.x - 15, y: leftPoint.y - 15, width: 30, height: 30)
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
        let rulerModel = RulerBelzierModel(ID: rulerTag, leftPoint: leftPoint, rightPoint: rightPoint, midPath: midPath, leftPath: leftPath, rightPath: rightPath, upPointLeft: upperPointOfLeftStraightLine, lowPointLeft: lowerPointOfLeftStraightLine, upPointRight: upperPointOfRightStraightLine, lowPointRight: lowerPointOfRightStraightLine)
        RulerModelArray.append(rulerModel)
    }
    
    func drawLeftRightLine(upPoint:CGPoint, lowerPoint:CGPoint){
        
    }
    
    func drawALine(point1:CGPoint,point2:CGPoint)->CAShapeLayer{
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 7
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }
    func drawTempLine(point1:CGPoint,point2:CGPoint, tempCAShapeLayer:CAShapeLayer){
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        tempCAShapeLayer.path = path.cgPath
        tempCAShapeLayer.strokeColor = UIColor.red.cgColor
        tempCAShapeLayer.lineWidth = 5
        self.layer.addSublayer(tempCAShapeLayer)
    }
  
}
