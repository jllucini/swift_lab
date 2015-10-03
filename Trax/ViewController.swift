//
//  ViewController.swift
//  Trax
//
//  Created by Jose Luis Lucini Reviriego on 3/10/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelegate = UIApplication.sharedApplication().delegate
        
        center.addObserverForName(GPXURL.Notification, object: appDelegate, queue: queue) { (notification) -> Void in
            if let url = notification.userInfo?[GPXURL.Key] as? NSURL {
                self.textView.text = "Recibido \(url)"
            }
        }
    }

}

