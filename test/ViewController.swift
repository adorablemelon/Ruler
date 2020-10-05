//
//  ViewController.swift
//  test
//
//  Created by Bao Le on 10/7/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var dragFrom: UILabel!
    private lazy var lineShape: CAShapeLayer = {
        let lineShape = CAShapeLayer()
        lineShape.strokeColor = UIColor.red.cgColor
        lineShape.lineWidth = 2.0
        return lineShape
    }()
    private var panGestureStartPoint: CGPoint = .zero
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(panGestureCalled(_:)))
    }()
    let DrawLineUserTouch:DrawLineWhenUserTouch = DrawLineWhenUserTouch()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        view.addSubview(DrawLineUserTouch)

        DrawLineUserTouch.translatesAutoresizingMaskIntoConstraints = false
        DrawLineUserTouch.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        DrawLineUserTouch.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        DrawLineUserTouch.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        DrawLineUserTouch.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }
    
    
    // MARK: Selectors
    @objc func panGestureCalled(_: UIPanGestureRecognizer) {
        let currentPanPoint = panRecognizer.location(in: self.view)
        switch panRecognizer.state {
        case .began:
            panGestureStartPoint = currentPanPoint
            self.view.layer.addSublayer(lineShape)
            
        case .changed:
            let linePath = UIBezierPath()
            linePath.move(to: panGestureStartPoint)
            linePath.addLine(to: currentPanPoint)
            
            lineShape.path = linePath.cgPath
        case .ended:
            lineShape.path = nil
            lineShape.removeFromSuperlayer()
        default: break
        }
    }
}
