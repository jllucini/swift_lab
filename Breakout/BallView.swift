//
//  BallView.swift
//  Breakout
//
//  Created by Jose Luis Lucini Reviriego on 20/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class BallView: UIView {

    var ballSize: CGSize {
        get {
            return CGSize(width:40, height:40)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.origin = frame.origin
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.bounds.size = ballSize
        let path = UIBezierPath(ovalInRect: CGRect(origin: CGPoint(x: 0, y: 0), size: ballSize))
        UIColor.brownColor().setFill()
        path.fill()
        UIColor.whiteColor().setFill()
    }

}
