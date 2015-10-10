//
//  WaypointImageViewController.swift
//  Trax
//
//  Created by Jose Luis Lucini Reviriego on 10/10/15.
//  Copyright © 2015 JLLucini. All rights reserved.
//

import UIKit

class WaypointImageViewController: ImageViewController {

    var waypoint: GPX.Waypoint? {
        didSet {
            imageURL = waypoint?.imageURL // our super's Model
            title = waypoint?.name
            updateEmbeddedMap()
        }
    }
    
    // we "prepare" for the embed segue
    // by grabbing the MVC that is embedded
    // we can then update it whenever it might need it
    
    var smvc: SimpleMapViewController?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Embed Map" {
            smvc = segue.destinationViewController as? SimpleMapViewController
            updateEmbeddedMap()
        }
    }
    
    func updateEmbeddedMap() {
        if let mapView = smvc?.mapView {
            mapView.mapType = .Hybrid
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(waypoint!)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }

}
