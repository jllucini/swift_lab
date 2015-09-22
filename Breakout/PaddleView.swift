//
//  PaddleView.swift
//  Breakout
//
//  Created by Jose Luis Lucini Reviriego on 22/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

@IBDesignable

class PaddleView: UIView {

    var bzPath: UIBezierPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame.origin = frame.origin
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.bounds.size = CGSize(width: 60, height:10)
        bzPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 60, height:10)))
        UIColor.brownColor().setFill()
        bzPath!.fill()
    }

    func setCollider(collider: UICollisionBehavior) {
        collider.addBoundaryWithIdentifier("paddle", forPath: UIBezierPath(rect: self.frame))
    }
}
