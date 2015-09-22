//
//  ViewController.swift
//  Breakout
//
//  Created by Jose Luis Lucini Reviriego on 19/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var gPaddle: PaddleView!
    
    var gBall = BallView(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width:40, height:40)))
    var gWall: BricksView?
    
    lazy var animator: UIDynamicAnimator = { UIDynamicAnimator(referenceView: self.view) }()
    
    lazy var pushBhvr: UIPushBehavior = {
        let items = [UIDynamicItem]()
        let lazilyCreatedBehavior = UIPushBehavior(items: items, mode: UIPushBehaviorMode.Instantaneous)
        lazilyCreatedBehavior.pushDirection = CGVector(dx: 1.0,dy: -1.0)
        return lazilyCreatedBehavior
    }()
    
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        lazilyCreatedCollider.collisionMode = UICollisionBehaviorMode.Everything
        return lazilyCreatedCollider
    }()
    
    lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedBlockBehavior = UIDynamicItemBehavior()
        lazilyCreatedBlockBehavior.allowsRotation = false
        lazilyCreatedBlockBehavior.elasticity = 1.0
        lazilyCreatedBlockBehavior.friction = 0.0
        lazilyCreatedBlockBehavior.resistance = 0.0
        return lazilyCreatedBlockBehavior
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gWall = BricksView(frame: self.view.bounds)
        collider.collisionDelegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        gPaddle.setCollider(collider)
        gWall?.createWall(collider)
        
        gameView.addSubview(gBall)
        gameView.addSubview(gPaddle!)
        gameView.addSubview(gWall!)
        
        
        animator.addBehavior(pushBhvr)
        animator.addBehavior(collider)
        animator.addBehavior(ballBehavior)
        
        collider.addItem(gBall)
        pushBhvr.addItem(gBall)
        ballBehavior.addItem(gBall)
    }
    
    
    @IBAction func movePaddle(gesture: UIPanGestureRecognizer) {
       switch gesture.state {
       case .Ended: fallthrough
       case .Changed:
            let translation = gesture.translationInView(self.view)
            gPaddle.center.x = gPaddle.center.x + translation.x
            collider.removeBoundaryWithIdentifier("paddle")
            gPaddle.setCollider(collider)
            gesture.setTranslation(CGPointZero, inView: self.view)
       default: break
       }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior!, beganContactForItem item: UIDynamicItem!, withBoundaryIdentifier identifier: NSCopying!, atPoint p: CGPoint) {
        let identf = "\(identifier)"
        gWall?.removeBrick("\(identifier)", collider: collider)
        
        // End conditions
        if (gWall?.gameFinished() == true) {
            animator.removeAllBehaviors()
            println("Super !!")
        }
        
        if p.y >= self.view.bounds.maxY-5 {
            animator.removeAllBehaviors()
            println("Game over")
        }
    }
    
}

