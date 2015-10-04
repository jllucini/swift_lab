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
        
        gpxURL = NSURL(string: "http://cs193p.stanford.edu/Vacation.gpx") // for demo/debug/testing
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
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier)
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view.canShowCallout = true
        } else {
            view.annotation = annotation
            view.canShowCallout = true
        }
        
        view.leftCalloutAccessoryView = nil
        if let waypoint = annotation as? GPX.Waypoint {
            if waypoint.thumbnailURL != nil {
                view.leftCalloutAccessoryView = UIImageView(frame: Constants.LeftCalloutFrame)
                // Don't fetch the image here: Load the image in another delegate 
                // (mapview:didSelectAnotationView)
                // In this method we are simly creating the pin and the assocaited callout view.
            }
        }
        
        return view
    }
    

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if let waypoint = view.annotation as? GPX.Waypoint {
            if let thumbnailImageView = view.leftCalloutAccessoryView as? UIImageView {
                if let url = waypoint.thumbnailURL {
                    let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
                    dispatch_async(dispatch_get_global_queue(qos, 0)) {
                        // Fetch the image async
                        if let imageData = NSData(contentsOfURL: url) {
                            // Go back to main queue and set the imageData
                            dispatch_async(dispatch_get_main_queue()) {
                                if url == waypoint.thumbnailURL!{
                                    if let image = UIImage(data: imageData) {
                                        thumbnailImageView.image = image
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
        static let AnnotationViewReuseIdentifier = "waypoint"
        static let ShowImageSegue = "Show Image"
        static let EditWaypointSegue = "Edit Waypoint"
        static let EditWaypointPopoverWidth: CGFloat = 320
    }

}

