//
//  GraphViewController.swift
//  Calculator
//
//  Created by Jose Luis Lucini Reviriego on 12/8/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {

    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
        }
    }
    
    private struct Constants {
        static let MoveOriginScale: CGFloat = 4
    }
    
    override func viewDidAppear(bool: Bool) {
        super.viewDidAppear(bool)
        
        // Do any additional setup after loading the view.
        graphView.resetOrigin(CGPoint(x: graphView.bounds.midX, y: graphView.bounds.midY))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI (){
        graphView.setNeedsDisplay()
    }
    
    //
    var graphFunctDS: FunctionDataSource?
    
    func oneVarFunction(gvValue: Double) -> Double?{
        var result: Double? = nil
        
        if let gfDS = graphFunctDS{
            result = gfDS.graphFunction(gvValue)
        }
        
        return result
    }


    @IBAction func changeOrigin(gesture: UIPanGestureRecognizer) {
        switch gesture.state{
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(graphView)
            let panMoveX = -Int(translation.x / Constants.MoveOriginScale)
            let panMoveY = -Int(translation.y / Constants.MoveOriginScale)
            if (panMoveX != 0 || panMoveY != 0){
                graphView.moveOrigin(translation)
                gesture.setTranslation(CGPointZero, inView: graphView)
            }
        default: break
        }
    }
    
    
    @IBAction func zoomGraph(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            graphView.axPPUnit *= gesture.scale
            gesture.scale = 1
            println("Scale \(graphView.axPPUnit)")
        }
    }
}
