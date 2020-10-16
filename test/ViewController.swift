//
//  ViewController.swift
//  test
//
//  Created by Bao Le on 10/7/20.
//  Copyright © 2020 Bao Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var rulerWidth:CGFloat = 200
    var rulerHeight:CGFloat = 40
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
    }()
      
    @objc func handleTap(recognizer: UIGestureRecognizer) {
        let rulerView:RulerUIView = RulerUIView()
        let touchPoint = recognizer.location(in: self.view)  // user touch point

        rulerView.frame = CGRect(x: touchPoint.x - rulerWidth/2, y: touchPoint.y - rulerHeight/2, width: rulerWidth, height: rulerHeight)
        view.addSubview(rulerView)
    }
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
        let logoutBarButtonItem = UIBarButtonItem(title: "ClearAll", style: .done, target: self, action: #selector(yourTapFunctionInsideView))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    /***********************************************************************************/
    
    func setupUIView(){
        view.addSubview(DrawLineUserTouch)
        DrawLineUserTouch.translatesAutoresizingMaskIntoConstraints = false
        DrawLineUserTouch.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        DrawLineUserTouch.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        DrawLineUserTouch.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        DrawLineUserTouch.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        //
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "image")!)
    }
   
    
    // MARK: Selectors
    @objc func yourTapFunctionInsideView() {
        DrawLineUserTouch.clearAll()
    }

    let DrawLineUserTouch:DrawLineWhenUserTouch = DrawLineWhenUserTouch()
}
