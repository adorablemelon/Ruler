//
//  ViewController2.swift
//  test
//
//  Created by Bao Le on 9/15/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(pan)
        let nextButton:UIButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
               nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
               nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
               nextButton.backgroundColor = .black
               nextButton.addTarget(self, action: #selector(nextPage), for: .touchDown)
        
        
    }

    @objc func nextPage(){
             let viewController = ViewController()
           self.navigationController?.pushViewController(viewController, animated: true)
               
       }
    private func createShapeLayer(for view: UIView) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.black.cgColor
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 3.0

        view.layer.addSublayer(shapeLayer)

        return shapeLayer
    }
    var angle : CGFloat = .pi * 2 * 3 / 4
    var lay = CAShapeLayer()
    private var shapeLayer: CAShapeLayer!
    private var origin: CGPoint!

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            shapeLayer = createShapeLayer(for: gesture.view!)
            origin = gesture.location(in: gesture.view)
        } else if gesture.state == .changed {
            let path = UIBezierPath()
            path.move(to: origin)
            path.addLine(to: gesture.location(in: gesture.view))
            shapeLayer.path = path.cgPath
        } else if gesture.state == .ended || gesture.state == .failed || gesture.state == .cancelled {
            shapeLayer = nil
        }
        
    }
    
}
