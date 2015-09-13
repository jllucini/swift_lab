//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Jose Luis Lucini Reviriego on 12/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

// Important, Remve checkbox "Adjust scroll view insets" from Controller's properties
class ImageViewController: UIViewController , UIScrollViewDelegate{


    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.bounds.size
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.5
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    var mediaItem: MediaItem? {
        didSet{
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    func fetchImage(){
        if let url = mediaItem!.url { // blocks main thread!
            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.mediaItem!.url {
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
