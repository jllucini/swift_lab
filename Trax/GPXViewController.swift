//
//  ViewController.swift
//  Trax
//
//  Created by Jose Luis Lucini Reviriego on 3/10/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

// Sample GPX:
// http://www.geovative.com/GeoTours/downloadTourGPX.asp?6174Vq=GEIF

import UIKit
import MapKit

class GPXViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!{
        didSet {
            mapView.mapType  = .Satellite
            mapView.delegate = self
        }
    }
    
    // Public API
    var gpxURL: NSURL? {
        didSet {
            clearWaypoints(); // Clear map
            if let url = gpxURL {
                GPX.parse(url) { (aGPX) -> Void in
                    if let gpx = aGPX {
                        self.handleWaypoints(gpx.waypoints)
                    }
                }
            }
        }
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelegate = UIApplication.sharedApplication().delegate
        
        center.addObserverForName(GPXURL.Notification, object: appDelegate, queue: queue) { (notification) -> Void in
            if let url = notification.userInfo?[GPXURL.Key] as? NSURL {
                self.gpxURL = url
            }
        }
    }
    
    // MARK: - View Aux Functions
    
    private func clearWaypoints(){
        if mapView?.annotations != nil {
            mapView.removeAnnotations(mapView.annotations as [MKAnnotation])
        }
    }
    
    private func handleWaypoints (waypoints: [GPX.Waypoint]){
        mapView.addAnnotations(waypoints)
        mapView.showAnnotations(waypoints, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    

}

