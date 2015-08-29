//
//  GraphView.swift
//  Calculator
//
//  Created by Jose Luis Lucini Reviriego on 12/8/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func oneVarFunction(gvValue: Double) -> Double?
}

@IBDesignable
class GraphView: UIView {

//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
        //axOrigin =  convertPoint(center, fromView: superview)
//    }
    
    @IBInspectable
    var axColor: UIColor = UIColor.blueColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var axScale:CGFloat = 1 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var axPPUnit: CGFloat = 1 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var axOrigin: CGPoint = CGPoint(x: 200, y: 200){
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var axMinX : CGFloat {
        var xMax: CGFloat = bounds.maxX-axOrigin.x
        return CGFloat((xMax-bounds.maxX)/axPPUnit)
    }
    
    private var axMaxX: CGFloat {
        var xMax: CGFloat = bounds.maxX-axOrigin.x
        return CGFloat(xMax/axPPUnit)
    }
    
    private var xIncr: CGFloat {
        return CGFloat( CGFloat(abs(axMaxX)+abs(axMinX)) / bounds.maxX   )
    }
    
    weak var dataSource: GraphViewDataSource?
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        var axDrawer = AxesDrawer(color: axColor, contentScaleFactor: axScale)
        axDrawer.drawAxesInRect(rect, origin: axOrigin, pointsPerUnit: axPPUnit)
       
        let path = UIBezierPath()
        UIColor.blackColor().setStroke()
        
        if let gvDS = dataSource {
            var oXi:CGFloat = CGFloat(axMinX)
            var oY0 = gvDS.oneVarFunction(Double(oXi))
            oXi += xIncr
            while oXi < CGFloat(axMaxX) {
                if let oY1: Double = gvDS.oneVarFunction(Double(oXi)){
                    path.moveToPoint(   transform( CGPoint(x: CGFloat(oXi-xIncr), y: CGFloat(oY0!)) ))
                    path.addLineToPoint(transform( CGPoint(x: CGFloat(oXi), y: CGFloat(oY1)) ))
                    oY0 = oY1
                }
                oXi += xIncr
            }
        }
        path.stroke()

/*        var faceR: CGFloat = min(bounds.size.width, bounds.size.height)/2
        let facePath = UIBezierPath(arcCenter: axOrigin, radius: faceR, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        UIColor.blackColor().setStroke()
        facePath.stroke()
*/
    }
    
    func moveOrigin (translation: CGPoint ){
        var auxPoint = axOrigin
        axOrigin = CGPointMake( auxPoint.x+translation.x,  auxPoint.y+translation.y)
    }
    
    private func transform(point: CGPoint) -> CGPoint {
        var result = point
        
        result.x = (result.x*axPPUnit + axOrigin.x);
        result.y = (result.y*axPPUnit + axOrigin.y);
        
        return result
    }
}
