//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Jose Luis Lucini Reviriego on 9/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

public enum TweetSection {
    case HashTags,URLs, Media, Users
}

public struct MentionsAdapter {

    private var sectionsToSequence = [TweetSection]()
    
    private var tweet: Tweet?
    
    public init(aTweet: Tweet?) {
        tweet = aTweet
        if tweet?.media.count > 0 {
            sectionsToSequence.append(TweetSection.Media)
        }
        
        if tweet?.hashtags.count > 0 {
            sectionsToSequence.append(TweetSection.HashTags)
        }
        
        if tweet?.urls.count > 0 {
            sectionsToSequence.append(TweetSection.URLs)
        }
        
        if tweet?.user != nil {
            sectionsToSequence.append(TweetSection.Users)
        }
    }
    
    
    public var numSections: Int{
        return sectionsToSequence.count;
    }
    
    public func rowsAt(section: Int) -> Int {
        var result = 0
        if section >= 0 {
            let tweetSection = sectionsToSequence[section]
            switch tweetSection {
            case .Media: result = tweet!.media.count
            case .HashTags: result = tweet!.hashtags.count
            case .URLs: result = tweet!.urls.count
            case .Users:
                if let t = tweet?.user {
                    result = 1
                }
            }
        }
        return result
    }
    
    public func labelAt(indexPath: NSIndexPath) -> String? {
        var result: String?
        
        if indexPath.section >= 0 && indexPath.row >= 0 {
            let tweetSection = sectionsToSequence[indexPath.section]
            switch tweetSection {
            case .Media:    result  = "\(tweet!.media[indexPath.row].url.absoluteString)"
            case .HashTags: result  = "\(tweet!.hashtags[indexPath.row].keyword)"
            case .URLs:     result  = "\(tweet!.urls[indexPath.row].keyword)"
            case .Users:    result  = "\(tweet!.user.description)"
            default: result = nil
            }
        }
        return result
    }
    
    public func headerAt(section: Int) -> String? {
        var result: String?
        let tweetSection = sectionsToSequence[section]
        switch tweetSection{
            case .Media: result = "Images"
            case .HashTags: result = "Hashtags"
            case .URLs: result = "URLs"
            case .Users: result = "Users"
            default: result = nil
        }
        return result
    }
    
}

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
            //return auxcell
        } else {
            var auxcell = tableView.dequeueReusableCellWithIdentifier("HashProtoCell", forIndexPath: indexPath) as HashProtoTableViewCell
            var labelData = mentionsAdapter!.labelAt(indexPath)
            auxcell.labelData = labelData
            cell = auxcell
            //return auxcell
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
