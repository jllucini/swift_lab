//
//  ViewController.swift
//  Breakout
//
//  Created by Jose Luis Lucini Reviriego on 19/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameView: UIView!
    
    var gBall = BallView(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width:40, height:40)))
    var gWall: BricksView?
    
    lazy var animator: UIDynamicAnimator = { UIDynamicAnimator(referenceView: self.view) }()
    
    lazy var pushBhvr: UIPushBehavior = {
        let items = [UIDynamicItem]()
        let lazilyCreatedBehavior = UIPushBehavior(items: items, mode: UIPushBehaviorMode.Instantaneous)
        lazilyCreatedBehavior.pushDirection = CGVector(dx: 1.0,dy: 1.0)
        return lazilyCreatedBehavior
    }()
    
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
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
    }

    override func viewDidLayoutSubviews()  {
        gWall?.createWall(collider)
        gameView.addSubview(gBall)
        gameView.addSubview(gWall!)
        animator.addBehavior(pushBhvr)
        animator.addBehavior(collider)
        animator.addBehavior(ballBehavior)
        collider.addItem(gBall)
        pushBhvr.addItem(gBall)
        ballBehavior.addItem(gBall)
    }
}

