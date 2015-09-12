//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Jose Luis Lucini Reviriego on 12/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

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
            let imageData = NSData(contentsOfURL: url)
            if imageData != nil {
                image = UIImage(data: imageData!)
            }
        }
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
