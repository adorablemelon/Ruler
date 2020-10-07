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
    
    private var tapGestureStartPoint: CGPoint = .zero
    
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
    
    @objc func handleLongPress(recognizer: UIGestureRecognizer) {
        var startPointOfTouchedRuler:CGPoint = .zero
        let zeroPoint:CGPoint = .zero
        
        let currentPanPoint = longTapRecognizer.location(in: self)
       // print("here",currentPanPoint)
        if let sublayers = self.layer.sublayers as? [CAShapeLayer]{ //get all CAShape and stored as an array
            for layer in sublayers{ // go through each CAShape
                if let path = layer.path, path.contains(currentPanPoint) { // if there is a path at that point then return, else create a path
                    startPointOfTouchedRuler = detectWhichRuler(layer: layer)
                    if startPointOfTouchedRuler != zeroPoint{
                        //  drawCircle(point: startPointOfTouchedRuler)
                        break
                    }else{
                    }
                }
            }
        }
        let linePath = UIBezierPath()
        var circlePath = UIBezierPath()
        var circlePath2 = UIBezierPath()
        
        let verticalLinePath1 = UIBezierPath()
        let verticalLinePath2 = UIBezierPath()

        switch longTapRecognizer.state {
        case .began:
            tapGestureStartPoint = startPointOfTouchedRuler
            if tapGestureStartPoint == zeroPoint {return}
            self.layer.addSublayer(lineShape)
            self.layer.addSublayer(shapeLayer1)
            self.layer.addSublayer(shapeLayer2)
            self.layer.addSublayer(verticalLineShape)
            self.layer.addSublayer(verticalLineShape2)
            shapeLayer1.anchorPoint = startPointOfTouchedRuler
      
            verticalLinePath1.move(to: CGPoint(x: startPointOfTouchedRuler.x, y: startPointOfTouchedRuler.y - dotLineSize ))
            verticalLinePath1.addLine(to: CGPoint(x: startPointOfTouchedRuler.x  , y: startPointOfTouchedRuler.y + dotLineSize))
            
            verticalLinePath2.move(to: CGPoint(x: currentPanPoint.x, y: currentPanPoint.y - dotLineSize))
            verticalLinePath2.addLine(to: CGPoint(x: currentPanPoint.x, y: currentPanPoint.y + dotLineSize))
            
            verticalLineShape.path = verticalLinePath1.cgPath
            verticalLineShape2.path = verticalLinePath2.cgPath

            linePath.move(to: tapGestureStartPoint)
            linePath.addLine(to: currentPanPoint)
            circlePath = UIBezierPath(arcCenter: currentPanPoint, radius: 15.0, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
            circlePath2 = UIBezierPath(arcCenter: startPointOfTouchedRuler, radius: 15.0, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
            shapeLayer2.path = circlePath2.cgPath
            shapeLayer1.path = circlePath.cgPath
            lineShape.path = linePath.cgPath
            
        case .changed:
            
            let centerPoint = currentDraggedPointNailed!
            let tempAngle = atan2(currentPanPoint.y - centerPoint.y, currentPanPoint.x - centerPoint.x)
            verticalLinePath1.move(to: CGPoint(x: currentDraggedPointNailed!.x, y: currentDraggedPointNailed!.y - dotLineSize ))
            verticalLinePath1.addLine(to: CGPoint(x: currentDraggedPointNailed!.x  , y: currentDraggedPointNailed!.y + dotLineSize))
            verticalLinePath1.rotate(path: verticalLinePath1, angle:tempAngle)
            verticalLineShape.path = verticalLinePath1.cgPath
            
//
            verticalLinePath2.move(to: CGPoint(x: currentPanPoint.x , y: currentPanPoint.y - dotLineSize))
            verticalLinePath2.addLine(to: CGPoint(x: currentPanPoint.x, y: currentPanPoint.y + dotLineSize))
            verticalLinePath2.rotate(path: verticalLinePath2, angle: tempAngle)

            verticalLineShape2.path = verticalLinePath2.cgPath

            linePath.move(to: tapGestureStartPoint)
            linePath.addLine(to: currentPanPoint)
            circlePath = UIBezierPath(arcCenter: currentPanPoint, radius: 15.0, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
            shapeLayer1.path = circlePath.cgPath
            circlePath.move(to: tapGestureStartPoint)
            lineShape.path = linePath.cgPath
            
            self.angle = tempAngle
        
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
            if tapGestureStartPoint == zeroPoint {return}
            extendALine(startPoint: tapGestureStartPoint, currentPoint: currentPanPoint, angle: angle!)
         //   drawLineFromPoint(start: tapGestureStartPoint, toPoint: currentPanPoint, ofColor: .red, inView: self)
            shouldDeleteRuler = true
            currentDraggedPointNailed = .zero
        default: print("default")
            break
        }
        
    }
    //------------------Transform---------------------
    

    

    
    
    //------------------Transform---------------------
    
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
    
    
    var bezierPathArray:[bezierPathStruct] = [bezierPathStruct]()
    
    func detectWhichRuler(layer: CAShapeLayer)->CGPoint{
        var newRulerStartPoint:CGPoint = .zero
        for (index,path)in self.bezierPathArray.enumerated(){
            for shape in path.arrayShapeLayer{
                if layer == shape {
                    if layer == path.circleEnd{
                        newRulerStartPoint = path.startPoint!
                        currentDraggedPointNailed = path.startPoint!
                        originalDraggingPoint = path.endPoint!
                    }else{
                        newRulerStartPoint = path.endPoint!
                        currentDraggedPointNailed = path.endPoint!
                        originalDraggingPoint = path.startPoint!
                    }
                    if shouldDeleteRuler {
                        print("deleted")
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
}

extension DrawLineWhenUserTouch{
    
    
    
    func extendALine(startPoint:CGPoint, currentPoint:CGPoint, angle: CGFloat){
        let endPoint = startPoint
        let startPoint = currentPoint
        dotStartPointX = CGPoint(x: startPoint.x, y: startPoint.y - dotLineSize)
        dotStartPointY = CGPoint(x: startPoint.x, y: startPoint.y + dotLineSize)
        dotEndPointX = CGPoint(x: endPoint.x, y: endPoint.y - dotLineSize)
        dotEndPointY = CGPoint(x: endPoint.x, y: endPoint.y + dotLineSize)
        
        let path = drawLineFromPoint(start: startPoint, toPoint: endPoint, ofColor: fillColor, angle: 0, inView: self)
        let dotStart = drawLineFromPoint(start: dotStartPointX!, toPoint: dotStartPointY!, ofColor: fillColor, angle: angle, inView: self)
        let dotEnd = drawLineFromPoint(start: dotEndPointX!, toPoint: dotEndPointY!, ofColor: fillColor, angle: angle, inView: self)
        let circleStart = drawCircle(point: startPoint)
        let circleEnd = drawCircle(point: endPoint)
        let newPath:bezierPathStruct = bezierPathStruct(startPoint: startPoint, endPoint: endPoint, dotStartPointX: dotStartPointX!, dotStartPointY: dotStartPointY!, dotEndPointX: dotEndPointX!, dotEndPointY: dotEndPointY!, path: path, dotStart: dotStart, dotEnd: dotEnd, circleStart: circleStart, circleEnd:circleEnd, angle: angle)
        
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
        
        
        let circleStart = drawCircle(point: startPoint!)
        let circleEnd = drawCircle(point: endPoint!)
        let newPath:bezierPathStruct = bezierPathStruct(startPoint: startPoint!, endPoint: endPoint!, dotStartPointX: dotStartPointX!, dotStartPointY: dotStartPointY!, dotEndPointX: dotEndPointX!, dotEndPointY: dotEndPointY!, path: path, dotStart: dotStart, dotEnd: dotEnd, circleStart: circleStart, circleEnd:circleEnd, angle: 0.0)
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
        //  shapeLayer.bounds = shapeLayer.path!.boundingBox
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
        
    }
    
   
}



