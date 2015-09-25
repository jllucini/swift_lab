//
//  ViewController.swift
//  Breakout
//
//  Created by Jose Luis Lucini Reviriego on 19/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameView: BreakoutView!
    @IBOutlet weak var gPaddle: PaddleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView?.addPaddleToPhisics(gPaddle)
    }
    
    @IBAction func movePaddle(gesture: UIPanGestureRecognizer) {
       switch gesture.state {
       case .Ended: fallthrough
       case .Changed:
            let translation = gesture.translationInView(self.view)
            gPaddle.center.x = gPaddle.center.x + translation.x
            gameView!.updatePaddleBoundaries(gPaddle)
            gesture.setTranslation(CGPointZero, inView: self.view)
       default: break
       }
    }
    
}

