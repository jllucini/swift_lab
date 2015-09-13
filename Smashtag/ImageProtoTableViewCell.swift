//
//  ImageProtoTableViewCell.swift
//  Smashtag
//
//  Created by Jose Luis Lucini Reviriego on 9/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class ImageProtoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    var mediaItem: MediaItem? {
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
        if let url = mediaItem!.url { // blocks main thread!
            let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                let imageData = NSData(contentsOfURL: self.mediaItem!.url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.mediaItem!.url {
                        if imageData != nil {
                            self.mediaImageView?.image = UIImage(data: imageData!)
                        } else {
                            self.mediaImageView?.image = nil
                        }
                    }
                }
            }
        }
    }

}
