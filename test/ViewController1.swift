//
//  ViewController1.swift
//  test
//
//  Created by Bao Le on 10/10/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import UIKit

class ViewController1: UIViewController {
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(panGestureCalled(_:)))
    }()
    
    /// The path that is being drawn (resets on .began, closes on .ended)
    private var linePath: UIBezierPath = .init()
    /// All of the layers added to the view
    private var shapes: [CAShapeLayer] = []
    
    override func viewDidLoad() {
         super.viewDidLoad()
               // Do any additional setup after loading the view.
               view.backgroundColor = .red
               let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: nil)
               self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
               let image : UIImage = UIImage(named:"image")!
               let imageView:UIImageView = UIImageView()
               imageView.image = image
               imageView.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(imageView)

               
               imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
               imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
               imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
               imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
               imageView.contentMode = .scaleAspectFit
               view.addSubview(imageView)
               
               self.view.addGestureRecognizer(panRecognizer)
        let nextButton:UIButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.backgroundColor = .red
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchDown)
    }
    
    @objc func nextPage(){
          let viewController = ViewController2()
        self.navigationController?.pushViewController(viewController, animated: true)
            
    }

    @objc private func panGestureCalled(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self.view)
        switch sender.state {
        case .began:
            // Reset the path
            linePath = .init()
            // Set the starting point
            linePath.move(to: point)
            // Creates a new layer when gesture starts.
            let layer = newShapeLayer()
            // Save the layer with all shapes.
            shapes.append(layer)
            // Add the layer to the view
            view.layer.addSublayer(layer)
        case .changed:
            // Update the current path to the new point
            linePath.addLine(to: point)
        case .ended:
            // Close/Finish the path
            linePath.close()
        default:
            break
        }
        
        // Update the most-current shape with the path being drawn.
        shapes.last?.path = linePath.cgPath
    }
    
    /// Creates a new `CAShapeLayer`
    private func newShapeLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = view.bounds
        layer.strokeColor = UIColor.blue.cgColor
        layer.lineWidth = 2.0
        return layer
    }
}


