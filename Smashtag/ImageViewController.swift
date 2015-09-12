//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Jose Luis Lucini Reviriego on 12/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var mediaItem: MediaItem? {
        didSet{
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI(){
        if mediaItem != nil {
            if let imageData = NSData(contentsOfURL: mediaItem!.url) { // blocks main thread!
                imageView?.image = UIImage(data: imageData)
            }
        }
    }

}
