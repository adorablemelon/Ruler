//
//  DrawLineWhenUserTouch.swift
//  test
//
//  Created by Bao Le on 9/24/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import UIKit

class DrawLineWhenUserTouch: UIView {
    
    required init() {
        print("init")
        super.init(frame: .zero)
        self.addGestureRecognizer(tapRecognizer)
        self.addGestureRecognizer(longTapRecognizer)
        self.currentDraggedPointNailed = .zero
        //clearButton.center = self.center
        //self.addSubview(clearButton)
      //  clearButton.bringSubviewToFront(self)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let clearButton:UIButton = {
        let button:UIButton = UIButton()
        button.backgroundColor = .orange
        button.setTitle("Clear", for: .normal)
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    let fillColor = UIColor.red
    
    let dotLineSize:CGFloat = 10
    var startPoint:CGPoint?
    var endPoint:CGPoint?
    var dotStartPointX:CGPoint?
    var dotStartPointY:CGPoint?
    var dotEndPointX:CGPoint?
    var dotEndPointY:CGPoint?
    struct bezierPathStruct{
        static var key:Int = 0
        var angle:CGFloat
        var startPoint:CGPoint?
        var endPoint:CGPoint?
        var dotStartPointX:CGPoint?
        var dotStartPointY:CGPoint?
        var dotEndPointX:CGPoint?
        var dotEndPointY:CGPoint?
        var path:CAShapeLayer?
        var dotStart:CAShapeLayer?
        var dotEnd:CAShapeLayer?
        var circleStart:CAShapeLayer?
        var circleEnd:CAShapeLayer?
        var arrayShapeLayer:[CAShapeLayer] = [CAShapeLayer]()
        var tag:Int?
        init(startPoint:CGPoint, endPoint:CGPoint, dotStartPointX:CGPoint, dotStartPointY:CGPoint, dotEndPointX:CGPoint, dotEndPointY:CGPoint, path:CAShapeLayer, dotStart:CAShapeLayer, dotEnd:CAShapeLayer, circleStart:CAShapeLayer, circleEnd:CAShapeLayer, angle:CGFloat) {
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.dotEndPointY = dotEndPointY
            self.dotEndPointX = dotEndPointX
            self.dotStartPointY = dotEndPointY
            self.dotStartPointX = dotEndPointX
            self.path = path
            self.dotStart = dotStart
            self.dotEnd = dotEnd
            self.circleEnd = circleEnd
            self.circleStart = circleStart
            self.angle = angle
            self.tag = bezierPathStruct.key
            print(self.tag)
            bezierPathStruct.key += 1
            arrayShapeLayer.append(contentsOf: [path,dotEnd,dotStart,circleStart,circleEnd])
            
        }
     
        func deleteRuler(){
            self.path?.removeFromSuperlayer()
            self.dotStart?.removeFromSuperlayer()
            self.dotEnd?.removeFromSuperlayer()
            self.circleStart?.removeFromSuperlayer()
            self.circleEnd?.removeFromSuperlayer()
            
        }
    }
    
    private var notTouchedPoint: CGPoint = .zero
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
    }()
    
    private lazy var longTapRecognizer: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
    }()
    
    
    @objc func handleTap(recognizer: UIGestureRecognizer) {
        print("1 tap")
        let originalPoint = recognizer.location(in: self)  // user touch point
        if let sublayers = self.layer.sublayers as? [CAShapeLayer]{ //get all CAShape and stored as an array
            for layer in sublayers{ // go through each CAShape
                if let path = layer.path, path.contains(originalPoint) { // if there is a path at that point then return, else create a path
                    print("hit: ",layer)
                   
                    return
                }
            }
            print("not hiting")
            drawWholeRuler(originalPoint: originalPoint)
        }else{
            print("not hiting")
            drawWholeRuler(originalPoint: originalPoint)
        }
        
    }
    
    var shouldDeleteRuler:Bool = true
    var isLongPressing:Bool = false //check if it is the first time long press or currently in longpress
    @objc func handleLongPress(recognizer: UIGestureRecognizer) {
        var startPointOfTouchedRuler:CGPoint = .zero
        let zeroPoint:CGPoint = .zero
        
        let currentPanPoint = longTapRecognizer.location(in: self)
           if let sublayers = self.layer.sublayers?.compactMap({ $0 as? CAShapeLayer }){ //get all CAShape and stored as an array
            for layer in sublayers{ // go through each CAShape
                if let path = layer.path, path.contains(currentPanPoint) { // if there is a path at that point then return, else create a path
                    
                    startPointOfTouchedRuler = detectWhichRuler(layer: layer)
                    if startPointOfTouchedRuler != zeroPoint{
                        break
                    }
                }else{}
            }
        }
        let linePath = UIBezierPath()
        var circlePath = UIBezierPath()
        var circlePath2 = UIBezierPath()
        
        let verticalLinePath1 = UIBezierPath()
        let verticalLinePath2 = UIBezierPath()
        
        switch longTapRecognizer.state {
        case .began:
            print("startPoint:",startPointOfTouchedRuler)

            notTouchedPoint = startPointOfTouchedRuler
            if notTouchedPoint == zeroPoint {return}
            self.layer.addSublayer(lineShape)
            self.layer.addSublayer(shapeLayer1)
            self.layer.addSublayer(shapeLayer2)
            self.layer.addSublayer(verticalLineShape)
            self.layer.addSublayer(verticalLineShape2)
            if currentDraggedPointNailed != nil{
                let centerPoint = currentDraggedPointNailed!
                let tempAngle = atan2(currentPanPoint.y - centerPoint.y, currentPanPoint.x - centerPoint.x)
                verticalLinePath1.move(to: CGPoint(x: startPointOfTouchedRuler.x, y: startPointOfTouchedRuler.y - dotLineSize ))
                verticalLinePath1.addLine(to: CGPoint(x: startPointOfTouchedRuler.x  , y: startPointOfTouchedRuler.y + dotLineSize))
                verticalLinePath1.rotate(path: verticalLinePath1, angle:tempAngle)
                verticalLinePath2.move(to: CGPoint(x: currentPanPoint.x, y: currentPanPoint.y - dotLineSize))
                verticalLinePath2.addLine(to: CGPoint(x: currentPanPoint.x, y: currentPanPoint.y + dotLineSize))
                verticalLinePath2.rotate(path: verticalLinePath2, angle:tempAngle)
                verticalLineShape.path = verticalLinePath1.cgPath
                verticalLineShape2.path = verticalLinePath2.cgPath
                verticalLineShape.path = verticalLinePath1.cgPath
                verticalLineShape2.path = verticalLinePath2.cgPath
                linePath.move(to: notTouchedPoint)
                linePath.addLine(to: currentPanPoint)
                circlePath = UIBezierPath(arcCenter: currentPanPoint, radius: 15.0, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
                circlePath2 = UIBezierPath(arcCenter: startPointOfTouchedRuler, radius: 15.0, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
                shapeLayer2.path = circlePath2.cgPath
                shapeLayer1.path = circlePath.cgPath
                lineShape.path = linePath.cgPath
            }
        case .changed:
            let centerPoint:CGPoint
            if currentDraggedPointNailed != nil{
                
                centerPoint = currentDraggedPointNailed!
                let tempAngle = atan2(currentPanPoint.y - centerPoint.y, currentPanPoint.x - centerPoint.x)
                verticalLinePath1.move(to: CGPoint(x: currentDraggedPointNailed!.x, y: currentDraggedPointNailed!.y - dotLineSize ))
                verticalLinePath1.addLine(to: CGPoint(x: currentDraggedPointNailed!.x  , y: currentDraggedPointNailed!.y + dotLineSize))
                verticalLinePath1.rotate(path: verticalLinePath1, angle:tempAngle)
                verticalLineShape.path = verticalLinePath1.cgPath
                verticalLinePath2.move(to: CGPoint(x: currentPanPoint.x , y: currentPanPoint.y - dotLineSize))
                verticalLinePath2.addLine(to: CGPoint(x: currentPanPoint.x, y: currentPanPoint.y + dotLineSize))
                verticalLinePath2.rotate(path: verticalLinePath2, angle: tempAngle)
                verticalLineShape2.path = verticalLinePath2.cgPath
                linePath.move(to: notTouchedPoint)
                linePath.addLine(to: currentPanPoint)
                circlePath = UIBezierPath(arcCenter: currentPanPoint, radius: 15.0, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
                shapeLayer1.path = circlePath.cgPath
                circlePath.move(to: notTouchedPoint)
                lineShape.path = linePath.cgPath
                self.angle = tempAngle
            }
        case .ended:
            verticalLineShape.path = nil
            verticalLineShape2.path = nil
            verticalLineShape2.removeFromSuperlayer()
            verticalLineShape.removeFromSuperlayer()
            
            shapeLayer2.path = nil
            shapeLayer2.removeFromSuperlayer()
            lineShape.path = nil
            shapeLayer1.path = nil
            lineShape.removeFromSuperlayer()
            shapeLayer1.removeFromSuperlayer()
            if notTouchedPoint == zeroPoint {return}
            extendALine(notTouchedPoint: notTouchedPoint, touchedPoint: currentPanPoint, angle: angle ?? 0.0)
         //   drawLineFromPoint(start: tapGestureStartPoint, toPoint: currentPanPoint, ofColor: .red, inView: self)
            shouldDeleteRuler = true
            currentDraggedPointNailed = .zero
            self.angle = 0.0
        default: print("default")
            break
        }
        
    }

 
    
    var isPathTouched:Bool = false
    var bezierPathArray:[bezierPathStruct] = [bezierPathStruct]()
    
    func detectWhichRuler(layer: CAShapeLayer)->CGPoint{
        var newRulerStartPoint:CGPoint = .zero
        for (index,path)in self.bezierPathArray.enumerated(){
            print(path.tag)
            for shape in path.arrayShapeLayer{
                if layer == shape {
                    
                    if layer == path.circleEnd || layer == path.dotEnd{
                        newRulerStartPoint = path.startPoint!
                        print("circle end")

                        if currentDraggedPointNailed == CGPoint.zero{
                            currentDraggedPointNailed = path.startPoint!
                        }
                        originalDraggingPoint = path.endPoint!
                        isPathTouched = false
                    }else if layer == path.circleStart || layer == path.dotStart{
                        newRulerStartPoint = path.endPoint!
                        print("circle start")

                        if currentDraggedPointNailed == CGPoint.zero{
                            currentDraggedPointNailed = path.endPoint!
                        }
                        originalDraggingPoint = path.startPoint!
                        isPathTouched = false

                    }else if layer == path.path{
                        isPathTouched = true
                    }
                    if shouldDeleteRuler {
                        path.deleteRuler()
                        bezierPathArray.remove(at: index)
                        shouldDeleteRuler = false
                    }
                    
                }
            }
        }
        return newRulerStartPoint
    }
    
    ///PanGesture
    
    var currentDraggedPointNailed:CGPoint?
    var originalDraggingPoint:CGPoint?
    var angle:CGFloat?
    var isUnitSet:Bool = false
    var unitValue:Float?
    let shapeLayer1: CAShapeLayer = {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.opacity = 0.5
        return shapeLayer
    }()
    
    let shapeLayer2: CAShapeLayer = {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.opacity = 0.5
        return shapeLayer
    }()
    private lazy var lineShape: CAShapeLayer = {
        let lineShape = CAShapeLayer()
        lineShape.strokeColor = UIColor.red.cgColor
        lineShape.lineWidth = 5.0
        return lineShape
    }()
    
    private lazy var verticalLineShape: CAShapeLayer = {
        let lineShape = CAShapeLayer()
        lineShape.strokeColor = UIColor.red.cgColor
        lineShape.lineWidth = 5.0
        return lineShape
    }()
    private lazy var verticalLineShape2: CAShapeLayer = {
        let lineShape = CAShapeLayer()
        lineShape.strokeColor = UIColor.red.cgColor
        lineShape.lineWidth = 5.0
        return lineShape
    }()
}

extension DrawLineWhenUserTouch{
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {return}

    }
    
    func createUIViewOutSideRuler(touchedPoint:CGPoint, notTouchedPoint:CGPoint, angle: CGFloat) -> UIView{
        let viewWidth = distanceFromTwoPoints(touchedPoint, notTouchedPoint)

        let view = UIView(frame: CGRect(x:notTouchedPoint.x, y: notTouchedPoint.y , width:  viewWidth, height: dotLineSize * 2))
        
        let vectorToStartPoint = CGPoint(x: view.center.x - touchedPoint.x,
                                                 y: view.center.y - touchedPoint.y )
        view.transform = CGAffineTransform(translationX: vectorToStartPoint.x, y: vectorToStartPoint.y)
                                     .rotated(by: angle)
                                     .translatedBy(x: -vectorToStartPoint.x, y: -vectorToStartPoint.y)
//     			    
        view.backgroundColor = .orange
        self.addSubview(view)
        return view
    }
    
    func createUILabel(midPoint:CGPoint, distance:CGFloat, angel:CGFloat, isUnitSet:Bool)->UIButton{
        var buttonText:String?
        if !isUnitSet{buttonText = "Enter unit"}
        let button = UIButton(frame: CGRect(x: midPoint.x, y: midPoint.y + 5, width: distance, height: 20))
      
        button.setTitle(buttonText, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = .red
        button.layer.borderWidth = 3.0

        if angle != nil {
            button.transform = CGAffineTransform(rotationAngle: angle!)}
        self.addSubview(button)
        return button
    }
    
    func extendALine(notTouchedPoint:CGPoint, touchedPoint:CGPoint, angle: CGFloat){
        let notTouchedPoint = notTouchedPoint
        let touchedPoint = touchedPoint
        dotStartPointX = CGPoint(x: touchedPoint.x, y: touchedPoint.y - dotLineSize)
        dotStartPointY = CGPoint(x: touchedPoint.x, y: touchedPoint.y + dotLineSize)
        dotEndPointX = CGPoint(x: notTouchedPoint.x, y: notTouchedPoint.y - dotLineSize)
        dotEndPointY = CGPoint(x: notTouchedPoint.x, y: notTouchedPoint.y + dotLineSize)
        let view = createUIViewOutSideRuler(touchedPoint: touchedPoint , notTouchedPoint: notTouchedPoint, angle: angle)

        let path = drawLineFromPoint(start: touchedPoint, toPoint: notTouchedPoint, ofColor: fillColor, angle: 0, inView: self)
        let dotStart = drawLineFromPoint(start: dotStartPointX!, toPoint: dotStartPointY!, ofColor: fillColor, angle: angle, inView: self)
        let dotEnd = drawLineFromPoint(start: dotEndPointX!, toPoint: dotEndPointY!, ofColor: fillColor, angle: angle, inView: self)
        let circleStart = drawCircle(point: touchedPoint)
        let circleEnd = drawCircle(point: notTouchedPoint)
        let newPath:bezierPathStruct = bezierPathStruct(startPoint: touchedPoint, endPoint: notTouchedPoint, dotStartPointX: dotStartPointX!, dotStartPointY: dotStartPointY!, dotEndPointX: dotEndPointX!, dotEndPointY: dotEndPointY!, path: path, dotStart: dotStart, dotEnd: dotEnd, circleStart: circleStart, circleEnd:circleEnd, angle: angle)
       // let distance = distanceFromTwoPoints(endPoint, startPoint)

       // let label = createUILabel(midPoint: endPoint, distance: distance, angel: angle, isUnitSet: false)

        bezierPathArray.append(newPath)
    }
    
    func drawWholeRuler(originalPoint:CGPoint){ //Draw a whole ruler with every components
        

        endPoint = CGPoint(x: originalPoint.x - 70, y: originalPoint.y)
        startPoint = CGPoint(x: originalPoint.x + 70, y: originalPoint.y)
        dotStartPointX = CGPoint(x: startPoint!.x, y: startPoint!.y - dotLineSize)
        dotStartPointY = CGPoint(x: startPoint!.x, y: startPoint!.y + dotLineSize)
        dotEndPointX = CGPoint(x: endPoint!.x, y: endPoint!.y - dotLineSize)
        dotEndPointY = CGPoint(x: endPoint!.x, y: endPoint!.y + dotLineSize)
        
        let path = drawLineFromPoint(start: startPoint!, toPoint: endPoint!, ofColor: fillColor, angle: 0, inView: self)
        let dotStart = drawLineFromPoint(start: dotStartPointX!, toPoint: dotStartPointY!, ofColor: fillColor, angle: 0, inView: self)
        let dotEnd = drawLineFromPoint(start: dotEndPointX!, toPoint: dotEndPointY!, ofColor: fillColor, angle: 0, inView: self)
        
        //let view = createUIViewOutSideRuler(startPoint: startPoint! , currentPoint: endPoint!, angle: 0, midPoint: endPoint!)

        let circleStart = drawCircle(point: startPoint!)
        let circleEnd = drawCircle(point: endPoint!)
        let newPath:bezierPathStruct = bezierPathStruct(startPoint: startPoint!, endPoint: endPoint!, dotStartPointX: dotStartPointX!, dotStartPointY: dotStartPointY!, dotEndPointX: dotEndPointX!, dotEndPointY: dotEndPointY!, path: path, dotStart: dotStart, dotEnd: dotEnd, circleStart: circleStart, circleEnd:circleEnd, angle: 0.0)
        //view.tag = newPath.tag!
       // let distance = distanceFromTwoPoints(endPoint!, startPoint!)

        //let label = createUILabel(midPoint: endPoint!, distance: distance, angel: 0.0, isUnitSet: false)
        bezierPathArray.append(newPath)
    }
    
    func drawCircle(point: CGPoint) -> CAShapeLayer{ //draw circle at 2 ends components
        let radius = dotLineSize + 5
        let circlePath = UIBezierPath(arcCenter: point, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = fillColor.cgColor
        shapeLayer.opacity = 0.5
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }
    func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor,angle:CGFloat, inView view:UIView) ->CAShapeLayer { //draw a straight line component
        
        //design the path
        let path = UIBezierPath()
        
        path.move(to: start)
        path.addLine(to: end)
        path.rotate(path: path, angle: angle)
        //design path in layerr
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 5
        // shapeLayer.bounds = shapeLayer.path!.boundingBox
        
        view.layer.addSublayer(shapeLayer)
        
        return shapeLayer
        
    }
    func clearAll(){
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        bezierPathArray.removeAll()
    }
    
   
}



