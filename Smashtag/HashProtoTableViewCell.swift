//
//  HashProtoTableViewCell.swift
//  Smashtag
//
//  Created by Jose Luis Lucini Reviriego on 9/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class HashProtoTableViewCell: UITableViewCell {

    @IBOutlet weak var hashLabel: UILabel!
    
    var labelData: String? {
        didSet{
            updateUI()
        }
    }
    
    var labelType: TweetSection? {
        didSet{
            if labelType == TweetSection.URLs {
                updateUI()
            }
        }
    }
    
    func updateUI(){
        if hashLabel != nil {
            if labelType == TweetSection.URLs {
                hashLabel.accessibilityTraits = UIAccessibilityTraitLink
                var tap = UITapGestureRecognizer(target: self, action: Selector("labelTapped:"))
                tap.numberOfTapsRequired = 1
                hashLabel.addGestureRecognizer(tap)
            }
            hashLabel.text = labelData
        }
    }
    
    func labelTapped(sender: UITapGestureRecognizer){
        if labelType == TweetSection.URLs {
            let theURL = NSURL(string: labelData!)
            UIApplication.sharedApplication().openURL(theURL!)
        }
    }

}
