//
//  DrawingUIViewByBelzier.swift
//  test
//
//  Created by Bao Le on 10/21/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import UIKit

class DrawingUIViewByBelzier: UIView {
    static var unitButtonValue = "0"

    var globalTag = 0
    var unitValue = 100.0
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
        let rightPoint = CGPoint(x: touchPoint.x + rulerViewWidth/2, y: touchPoint.y)
        let leftPoint = CGPoint(x: touchPoint.x - rulerViewWidth/2, y: touchPoint.y)
        drawRuler(middlePoint:touchPoint, rightPoint: rightPoint, leftPoint: leftPoint, angle: 0)
    }
    
    var tempPathCAShapeLayer = CAShapeLayer()
    var tempRightCAShapeLayer = CAShapeLayer()
    var tempLeftCAShapeLayer = CAShapeLayer()
    var tempUnitButton = UIButton()
    var isRightButton:Bool = false
    var valuePerUnit:Float = Float(0)
    
    var originalLeftPointMove:CGPoint = .zero
    var originalRightPointMove:CGPoint = .zero
    var originalTouchPointMove:CGPoint = .zero
    var originalButtonLeftPoint:CGPoint = .zero
    var originalButtonRightPoint:CGPoint = .zero
    var originalUnitButtonPoint:CGPoint = .zero
    var currentTag:Int = Int.max
    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer){
        let touchPoint = recognizer.location(in: self)
        let yOffSet = touchPoint.y - originalTouchPointMove.y
        let xOffSet = touchPoint.x - originalTouchPointMove.x
        let leftPoint = CGPoint(x: originalLeftPointMove.x + xOffSet, y: originalLeftPointMove.y + yOffSet)
        let rightPoint = CGPoint(x: originalRightPointMove.x + xOffSet, y: originalRightPointMove.y + yOffSet)
        if recognizer.state == .began{
            for each in RulerModelArray{
                if touchPoint.contained(byStraightLine: each.leftPoint, to: each.rightPoint, tolerance: 20) == true{
                    currentTag = each.ID
                    originalLeftPointMove = RulerModelArray[currentTag].leftPoint
                    originalRightPointMove = RulerModelArray[currentTag].rightPoint
                    originalAngle = RulerModelArray[currentTag].angle
                    originalTouchPointMove = touchPoint
                    RulerModelArray[currentTag].removePath()
                    originalUnitButtonPoint = RulerModelArray[currentTag].unitButton.center
                    break
                }
            }
        }
        if recognizer.state == .changed{
            if currentTag != Int.max{
                drawTempLine(point1: leftPoint,point2: rightPoint, tempCAShapeLayer: tempPathCAShapeLayer, angle: 0)
                drawTempLine(point1: CGPoint(x: leftPoint.x, y: leftPoint.y + 10), point2: CGPoint(x: leftPoint.x, y: leftPoint.y - 10), tempCAShapeLayer: tempRightCAShapeLayer, angle: originalAngle)
                drawTempLine(point1: CGPoint(x: rightPoint.x, y: rightPoint.y + 10), point2: CGPoint(x: rightPoint.x, y: rightPoint.y - 10), tempCAShapeLayer: tempLeftCAShapeLayer, angle: originalAngle)
                RulerModelArray[currentTag].leftButton.center.x = originalLeftPointMove.x + xOffSet
                RulerModelArray[currentTag].leftButton.center.y = originalLeftPointMove.y + yOffSet
                RulerModelArray[currentTag].rightButton.center.x = originalRightPointMove.x + xOffSet
                RulerModelArray[currentTag].rightButton.center.y = originalRightPointMove.y + yOffSet
                RulerModelArray[currentTag].unitButton.center.x = originalUnitButtonPoint.x + xOffSet
                RulerModelArray[currentTag].unitButton.center.y = originalUnitButtonPoint.y + yOffSet
            }
            
        }
        if recognizer.state == .ended{
            if currentTag != Int.max{
                substituteRulerAfterMove(ID: currentTag, leftPoint: leftPoint, RighPoint: rightPoint, angle: originalAngle)
            }
            originalLeftPointMove = .zero
            originalRightPointMove = .zero
            originalTouchPointMove = .zero
            originalUnitButtonPoint = .zero
            currentTag = Int.max
        }
        
    }
    
    var originalAngle = CGFloat(0)
    var changedAngle = CGFloat(0)
    var originalUnitButtonCenter:CGPoint = .zero // use to rotate button
    var initialAngle = CGFloat(0) //use to rotate button
    var angle = CGFloat(0) // use to rotate button
    var currentAnglePoint:CGPoint = .zero
    var currentTouchedPosition:modifiedButton.positionEnum = .unitText
    var buttonPoint:CGPoint = .zero
    @objc func handleButtonLongPress(recognizer: UIGestureRecognizer) {
        let touchPoint = recognizer.location(in: self)
        guard let button = recognizer.view as? modifiedButton else { return }
        let rulerID = button.tag
        var tempAngle = CGFloat(0)
        switch recognizer.state {
        case .began:
            button.shake()

            button.center = touchPoint
            RulerModelArray[rulerID].removePath()
            RulerModelArray[rulerID].removeButton()
            originalAngle = RulerModelArray[rulerID].angle
            nailPoint = nonTouchedButtonPosition(ID: rulerID, position: button.position)
            drawTempLine(point1: nailPoint, point2: touchPoint, tempCAShapeLayer: tempPathCAShapeLayer, angle: 0) // MIDDLE LINE
            drawTempLine(point1: CGPoint(x: nailPoint.x, y: nailPoint.y + 10), point2: CGPoint(x: nailPoint.x, y: nailPoint.y - 10), tempCAShapeLayer: tempRightCAShapeLayer, angle: originalAngle)
            drawTempLine(point1: CGPoint(x: button.center.x, y: button.center.y + 10), point2: CGPoint(x: button.center.x, y: button.center.y - 10), tempCAShapeLayer: tempLeftCAShapeLayer, angle: originalAngle)
            currentAnglePoint = CGPoint(x: 0, y: 0)
            currentTouchedPosition = button.position
            tempAngle = atan2(touchPoint.y - nailPoint.y, touchPoint.x - nailPoint.x)
            changedAngle = tempAngle
            if currentTouchedPosition == .left{
                buttonPoint = touchPoint
            }
            if currentTouchedPosition == .right{
                buttonPoint = nailPoint
            }
        case .changed:
            if currentTouchedPosition == .left{
                tempAngle = atan2(touchPoint.y - nailPoint.y, touchPoint.x - nailPoint.x) - .pi
                buttonPoint = touchPoint
            }
            if currentTouchedPosition == .right{
                tempAngle = atan2(touchPoint.y - nailPoint.y, touchPoint.x - nailPoint.x)
            }
            changedAngle = tempAngle
            print(tempAngle)
            if touchPoint != originalTouchPointMove{
                button.center = touchPoint
                drawTempLine(point1: nailPoint, point2: touchPoint, tempCAShapeLayer: tempPathCAShapeLayer, angle: 0) // middle line
                drawTempLine(point1: CGPoint(x: nailPoint.x, y: nailPoint.y + 10), point2: CGPoint(x: nailPoint.x, y: nailPoint.y - 10), tempCAShapeLayer: tempRightCAShapeLayer, angle: tempAngle)
                drawTempLine(point1: CGPoint(x: button.center.x, y: button.center.y + 10), point2: CGPoint(x: button.center.x, y: button.center.y - 10), tempCAShapeLayer: tempLeftCAShapeLayer, angle: tempAngle)
                let distance = distanceFromTwoPoints(nailPoint, touchPoint)
                var unitValue = distance * CGFloat(valuePerUnit)
                if DrawingUIViewByBelzier.unitButtonValue == "0" {
                    unitValue = 0
                }
                drawTempUnitButton(buttonPoint: buttonPoint, unitButtonWidth: distance, anchorPoint: currentAnglePoint, angle: tempAngle, button: tempUnitButton, unitValue: unitValue)
            }
            
        case .ended:
            substituteRulerAfterStretch(ID: rulerID, positionOfMovedButton: button.position, newPosition: touchPoint, angle: changedAngle, anglePoint: currentAnglePoint, anchorPoint: currentAnglePoint)
            tempLeftCAShapeLayer.removeFromSuperlayer()
            tempRightCAShapeLayer.removeFromSuperlayer()
            tempPathCAShapeLayer.removeFromSuperlayer()
            tempUnitButton.removeFromSuperview()
                        
        default: print("default")
            break
        }
    }
}

extension DrawingUIViewByBelzier{
    func substituteRulerAfterStretch(ID:Int,positionOfMovedButton:modifiedButton.positionEnum, newPosition:CGPoint, angle:CGFloat,anglePoint:CGPoint, anchorPoint:CGPoint){
        let newLine = drawALine(point1: nailPoint, point2: newPosition, angle: 0) // middle line
        let rightNewLine = drawALine(point1: CGPoint(x: nailPoint.x, y: nailPoint.y + 10), point2: CGPoint(x: nailPoint.x, y: nailPoint.y - 10), angle: angle)
        let leftNewLine = drawALine(point1: CGPoint(x: newPosition.x, y: newPosition.y + 10), point2: CGPoint(x: newPosition.x, y: newPosition.y - 10), angle: angle)
        var newUnitButton:modifiedButton = modifiedButton(position: .unitText)
        if positionOfMovedButton == .right{
            newUnitButton = drawButton(buttonPoint: nailPoint, unitButtonWidth: distanceFromTwoPoints(nailPoint, newPosition), rulerTag: ID, position: .unitText, angle: angle, anchorPoint: anchorPoint)
        }
        if positionOfMovedButton == .left{
            newUnitButton = drawButton(buttonPoint: newPosition, unitButtonWidth: distanceFromTwoPoints(nailPoint, newPosition), rulerTag: ID, position: .unitText, angle: angle, anchorPoint: anchorPoint)
        }
            
        RulerModelArray[ID].midPath = newLine
        RulerModelArray[ID].leftPath = leftNewLine
        RulerModelArray[ID].rightPath = rightNewLine
        RulerModelArray[ID].angle = angle
        RulerModelArray[ID].unitButton = newUnitButton
        if positionOfMovedButton == .left{
            RulerModelArray[ID].leftPoint = newPosition
        }
        if positionOfMovedButton == .right{

            RulerModelArray[ID].rightPoint = newPosition
        }
    }
    
    func substituteRulerAfterMove(ID:Int, leftPoint:CGPoint, RighPoint:CGPoint, angle:CGFloat){
        let newLine = drawALine(point1: leftPoint, point2: RighPoint, angle: 0) // middle line
        let rightNewLine = drawALine(point1: CGPoint(x: RighPoint.x, y: RighPoint.y + 10), point2: CGPoint(x: RighPoint.x, y: RighPoint.y - 10), angle: angle)
        let leftNewLine = drawALine(point1: CGPoint(x: leftPoint.x, y: leftPoint.y + 10), point2: CGPoint(x: leftPoint.x, y: leftPoint.y - 10), angle: angle)
        RulerModelArray[ID].midPath = newLine
        RulerModelArray[ID].leftPath = leftNewLine
        RulerModelArray[ID].rightPath = rightNewLine
        RulerModelArray[ID].leftPoint = leftPoint
        RulerModelArray[ID].rightPoint = RighPoint
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
    
    func drawRuler(middlePoint:CGPoint, rightPoint:CGPoint, leftPoint:CGPoint,angle:CGFloat){
        let rulerTag = globalTag
        let upperPointOfLeftStraightLine = CGPoint(x: leftPoint.x, y: leftPoint.y + 10)
        let lowerPointOfLeftStraightLine = CGPoint(x: leftPoint.x, y: leftPoint.y - 10)
        let upperPointOfRightStraightLine = CGPoint(x: rightPoint.x, y: rightPoint.y + 10)
        let lowerPointOfRightStraightLine = CGPoint(x: rightPoint.x, y: rightPoint.y - 10)
        let distanceBetweenLeftAndRight = distanceFromTwoPoints(leftPoint, rightPoint)
        let leftButton = drawButton(buttonPoint: leftPoint, unitButtonWidth: 0, rulerTag: globalTag, position: .left, angle: 0,anchorPoint: .zero)
        let rightButton = drawButton(buttonPoint: rightPoint, unitButtonWidth: 0, rulerTag: globalTag, position: .right, angle: 0, anchorPoint: .zero)
        let unitButton = drawButton(buttonPoint: leftPoint, unitButtonWidth: distanceBetweenLeftAndRight, rulerTag: globalTag, position: .unitText,angle: 0,anchorPoint: .zero)
        globalTag += 1
        
        let midPath = drawALine(point1: leftPoint, point2: rightPoint, angle: angle)
        let leftPath = drawALine(point1: upperPointOfLeftStraightLine, point2: lowerPointOfLeftStraightLine, angle: angle)
        let rightPath = drawALine(point1: upperPointOfRightStraightLine, point2: lowerPointOfRightStraightLine, angle: angle)
        let rulerModel = RulerBelzierModel(ID: rulerTag, leftPoint: leftPoint, rightPoint: rightPoint, midPath: midPath, leftPath: leftPath, rightPath: rightPath, upPointLeft: upperPointOfLeftStraightLine, lowPointLeft: lowerPointOfLeftStraightLine, upPointRight: upperPointOfRightStraightLine, lowPointRight: lowerPointOfRightStraightLine, leftButton: leftButton, rightButton: rightButton, angle: 0.0, unitValue: Float(unitValue), unitButton: unitButton)
        RulerModelArray.append(rulerModel)
    }
    
    func drawButton(buttonPoint:CGPoint, unitButtonWidth:CGFloat, rulerTag:Int, position:modifiedButton.positionEnum,angle:CGFloat, anchorPoint:CGPoint)->modifiedButton{
        let button = modifiedButton(position: position)
        if position == .left || position == .right{
            button.frame =  CGRect(x: buttonPoint.x - 15, y: buttonPoint.y - 15, width: 30, height: 30)
            self.addSubview(button)
            button.clipsToBounds = true
            button.backgroundColor = .red
            button.layer.cornerRadius = 30/2
            button.alpha = 0.3
            button.layer.cornerRadius = 30/2
            button.tag = rulerTag
            let buttonGes: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleButtonLongPress(recognizer:)))
            button.addGestureRecognizer(buttonGes)
        }
        else if position == .unitText{
            button.frame =  CGRect(x: buttonPoint.x, y: buttonPoint.y + 5, width: unitButtonWidth, height: 30)
            self.addSubview(button)
            var buttonTxt = "should not return this"
            if DrawingUIViewByBelzier.unitButtonValue == "0"{
                buttonTxt = "Adjust measure"
            }else{
                buttonTxt = String(DrawingUIViewByBelzier.unitButtonValue )
            }
            
            button.setTitle(buttonTxt, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.setTitleColor(.red, for: .normal)
            button.titleLabel?.font = .boldSystemFont(ofSize: 16)
            button.backgroundColor = UIColor.clear
            button.addTarget(self, action: #selector(changeMeasureUnit(sender:)), for: .touchDown)
            button.setAnchorPoint(anchorPoint)
            let transform = CGAffineTransform(rotationAngle: angle)
            button.transform = transform

        }
        return button
      
    }

    func drawTempUnitButton(buttonPoint:CGPoint, unitButtonWidth:CGFloat, anchorPoint:CGPoint, angle:CGFloat, button:UIButton, unitValue:CGFloat){
        self.addSubview(button)
        button.frame = CGRect(x: buttonPoint.x, y: buttonPoint.y + 5, width: 0, height: 0)
        button.bounds.size.width = unitButtonWidth
        button.bounds.size.height = 30
        
        var buttonTxt = "Adjust measure"
        if unitValue != 0 {
            let floatUnitValue = Float(unitValue)
            buttonTxt = String(floatUnitValue)
        }
        
        button.setTitle(buttonTxt, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.clear
        button.setAnchorPoint(anchorPoint)
        let transform = CGAffineTransform(rotationAngle: angle)
        button.transform = transform

    }
    
    @objc func changeMeasureUnit(sender:UIButton){
        let alert = UIAlertController(title: "Set floor plan scale", message: "Note: to set GPS coordinates, select the ruler and tap on the end points", preferredStyle: .alert)
               alert.addTextField { (textField) in
                   textField.placeholder = "Inpzut ruler length (ft)"
            
               }
        alert.addAction(UIAlertAction(title: "Scale Plane", style: .cancel, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0]{
                if textField.text! != ""{
                    let text = textField.text!
                    let textInt = Float(text)
                    let a = self.RulerModelArray[sender.tag].leftPoint
                    let b = self.RulerModelArray[sender.tag].rightPoint
                    let distance = Float(self.distanceFromTwoPoints(a, b))
                    self.valuePerUnit = Float(distance/textInt!)
                    DrawingUIViewByBelzier.unitButtonValue = String(textField.text!)
                    sender.setTitle(textField.text, for: .normal)
                }else{
                    sender.setTitle("Adjust measure", for: .normal)
                }
                self.setNeedsDisplay()
            }else{
                return
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancle", style: .default, handler: .none))


        self.window?.rootViewController?.present(alert, animated: false, completion: nil)
        
    }
    
    func drawALine(point1:CGPoint,point2:CGPoint,angle: CGFloat)->CAShapeLayer{
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.rotate(path: path, angle: angle)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }
    func drawTempLine(point1:CGPoint,point2:CGPoint, tempCAShapeLayer:CAShapeLayer, angle:CGFloat){
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.rotate(path: path, angle: angle)
        tempCAShapeLayer.path = path.cgPath
        tempCAShapeLayer.strokeColor = UIColor.red.cgColor
        tempCAShapeLayer.lineWidth = 10
        self.layer.addSublayer(tempCAShapeLayer)
    }
    func createUIViewOutSideRuler(touchedPoint:CGPoint, notTouchedPoint:CGPoint, angle: CGFloat, tag: Int) -> modifedUIView{
        let viewWidth = distanceFromTwoPoints(touchedPoint, notTouchedPoint) + 20
        let viewHeight:CGFloat = 20.0
        let frame = CGRect(x:touchedPoint.x - 10, y: notTouchedPoint.y  , width:  viewWidth, height: viewHeight)
        let view = modifedUIView(tag:tag, frame: frame)
        self.addSubview(view)
        return view
    }
    
}
