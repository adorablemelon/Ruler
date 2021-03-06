//
//  ViewController.swift
//  test
//
//  Created by Bao Le on 10/7/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
   
    
    
    let drawingView:DrawingUIView = DrawingUIView()
    var currentUsingRulerView:UIView = UIView()
    let drawLineView:DrawLineWhenUserTouch = DrawLineWhenUserTouch()
    let DrawWithBelzier:DrawingUIViewByBelzier = DrawingUIViewByBelzier()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let logoutBarButtonItem = UIBarButtonItem(title: "ClearAll", style: .done, target: self, action: #selector(yourTapFunctionInsideView))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        setupUIView()
    }
    
    /***********************************************************************************/
    
    func setupUIView(){
        view.addSubview(DrawWithBelzier)
        DrawWithBelzier.translatesAutoresizingMaskIntoConstraints = false
        DrawWithBelzier.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        DrawWithBelzier.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        DrawWithBelzier.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        DrawWithBelzier.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        DrawWithBelzier.backgroundColor = .blue
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "image")!)
    }
    func setupUIView2(){
        view.addSubview(drawLineView)
        drawLineView.translatesAutoresizingMaskIntoConstraints = false
        drawLineView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        drawLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        drawLineView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        drawLineView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        drawLineView.backgroundColor = .blue
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "image")!)
    }
   
    
    // MARK: Selectors
    @objc func yourTapFunctionInsideView() {
        DrawLineUserTouch.clearAll()
    }

    let DrawLineUserTouch:DrawLineWhenUserTouch = DrawLineWhenUserTouch()
}
