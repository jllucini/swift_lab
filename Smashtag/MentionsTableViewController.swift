//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Jose Luis Lucini Reviriego on 9/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit



class MentionsTableViewController: UITableViewController {
    
    @IBOutlet weak var TableViewHeader: UINavigationItem!
    
    var mentionsAdapter: MentionsAdapter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        TableViewHeader.title = mentionsAdapter?.tweet?.user.name
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentionsAdapter!.numSections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionsAdapter!.rowsAt(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if indexPath.section == 0 && mentionsAdapter?.tweet?.media.count > 0 {
            var auxcell = tableView.dequeueReusableCellWithIdentifier("ImageProtoCell", forIndexPath: indexPath) as ImageProtoTableViewCell
            if let mediaItem = mentionsAdapter?.tweet?.media[indexPath.row] {
                auxcell.mediaItem = mediaItem
            }
            cell = auxcell
        } else {
            var auxcell = tableView.dequeueReusableCellWithIdentifier("HashProtoCell", forIndexPath: indexPath) as HashProtoTableViewCell
            var labelData   = mentionsAdapter!.labelAt(indexPath)
            let sectionType = mentionsAdapter!.sectionAt(indexPath)
            auxcell.labelData = labelData
            auxcell.labelType = sectionType
            cell = auxcell
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        println("titleForHeaderInSection \(section) - \(mentionsAdapter!.headerAt(section))")
        return mentionsAdapter!.headerAt(section)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && mentionsAdapter?.tweet?.media.count > 0 {
            var estimate : CGFloat = 120.0
            if let mediaItem = mentionsAdapter?.tweet?.media[indexPath.row] {
                let imgWidth  = tableView.frame.width
                estimate = imgWidth / CGFloat(mediaItem.aspectRatio)
            }
            return estimate
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goBackMain"{
            let hashCell = sender as? HashProtoTableViewCell
            var ttvc = segue.destinationViewController as TweetTableViewController
            if let label = hashCell?.labelData {
                ttvc.searchText = label.hasPrefix("#") ? label : "#\(label)"
            }
        } else if segue.identifier == "ShowImageDetail" {
            let nav = segue.destinationViewController as UINavigationController
            let ivc = nav.topViewController as ImageViewController
            ivc.mediaItem = mentionsAdapter?.tweet?.media[0]
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        var doSegue = true
        if identifier == "goBackMain"{
            let hashCell = sender as? HashProtoTableViewCell
            if let label = hashCell?.labelType {
                if label == TweetSection.URLs {
                    doSegue = false
                }
            }
        }
        
        return doSegue
    }

}
