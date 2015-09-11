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
        if let imageData = NSData(contentsOfURL: mediaItem!.url) { // blocks main thread!
            mediaImageView?.image = UIImage(data: imageData)
        }
    }

}
