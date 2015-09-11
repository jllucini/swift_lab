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
    
    func updateUI(){
        if hashLabel != nil { // blocks main thread!
            hashLabel.text = labelData
        }
    }
}
