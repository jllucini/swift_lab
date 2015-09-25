//
//  BreakoutView.swift
//  Breakout
//
//  Created by Jose Luis Lucini Reviriego on 25/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class BreakoutView: UIView, UICollisionBehaviorDelegate {
    
    var gBall = BallView(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width:40, height:40)))
    var gWall: BricksView?
    
    lazy var animator: UIDynamicAnimator = { UIDynamicAnimator(referenceView: self) }()
    
    let breakoutBehavior = BreakoutBehavior()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        breakoutBehavior.collider.collisionDelegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        breakoutBehavior.collider.collisionDelegate = self
    }
    
    override func drawRect(rect: CGRect) {
        if gWall == nil {
            gWall = BricksView(frame: self.bounds)
        }
        
        gWall?.createWall(breakoutBehavior.collider)
        
        self.addSubview(gBall)
        self.addSubview(gWall!)
        animator.addBehavior(breakoutBehavior)
        breakoutBehavior.addItem(gBall)
    }
    
    
    func collisionBehavior(behavior: UICollisionBehavior!, beganContactForItem item: UIDynamicItem!, withBoundaryIdentifier identifier: NSCopying!, atPoint p: CGPoint) {
        let identf = "\(identifier)"
        gWall?.removeBrick("\(identifier)", collider: breakoutBehavior.collider)
        
        // End conditions
        if (gWall?.gameFinished() == true) {
            animator.removeAllBehaviors()
            println("Super !!")
        }
        
        if p.y >= bounds.maxY-5 {
            animator.removeAllBehaviors()
            println("Game over")
        }
    }
    
    func addPaddleToPhisics(gPaddle: PaddleView){
        gPaddle.setCollider(breakoutBehavior.collider)
        self.addSubview(gPaddle)
    }
    
    func updatePaddleBoundaries(gPaddle: PaddleView) {
        breakoutBehavior.collider.removeBoundaryWithIdentifier("paddle")
        gPaddle.setCollider(breakoutBehavior.collider)
    }

}
