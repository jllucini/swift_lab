//
//  BrickView.swift
//  Breakout
//
//  Created by Jose Luis Lucini Reviriego on 20/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class BricksView: UIView {
    
    enum BrickStatus {
        case Visible, Invisible
    }
    
    struct Brick {
        var name: String
        var status: BrickStatus
        var path: UIBezierPath
    }
    
    struct Constants {
        static let NumBricks = 10
        static let DefaultWidth: CGFloat = 40.0
        static let BrickSize = CGSize(width: DefaultWidth, height:20)
    }
    
    private var wall = [Brick]()
    
    var numBricks : Int {
        get {
            return Int(CGFloat(self.bounds.width) / CGFloat(Constants.DefaultWidth))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.0)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func drawRect(rect: CGRect) {
        UIColor.blackColor().setStroke()
        UIColor.grayColor().setFill()
        for brick in wall {
            if brick.status == .Visible {
                brick.path.stroke()
                brick.path.fill()
            }
        }
    }

    func createWall(collider: UICollisionBehavior) {
        for ix in 0...numBricks-1{
            let x: CGFloat = CGFloat(ix) * Constants.DefaultWidth
            let y: CGFloat = 50.0
            var point = CGPoint(x: x, y: y)
            var rect = CGRect(origin: point, size: Constants.BrickSize)
            var path = UIBezierPath(rect: rect)
            var brick = Brick(name: "\(ix)", status: BrickStatus.Visible, path: path)
            wall.append(brick)
            collider.addBoundaryWithIdentifier(brick.name, forPath: brick.path)
        }
    }
    
}
