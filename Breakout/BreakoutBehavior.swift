//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Jose Luis Lucini Reviriego on 25/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class BreakoutBehavior: UIDynamicBehavior {
 
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
    
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
        addChildBehavior(pushBhvr)
    }
    
    func addItem(aView: UIView){
        collider.addItem(aView)
        pushBhvr.addItem(aView)
        ballBehavior.addItem(aView)
    }
    
}
