//
//  HistoryTableViewController.swift
//  Smashtag
//
//  Created by Jose Luis Lucini Reviriego on 13/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    var userHistory : UserSavedData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        if let uh = userHistory?.retrieveHistory() {
            return 1
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let uh = userHistory?.retrieveHistory() {
            return uh.count
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = userHistory?.retrieveHistory()[indexPath.row]
        var tap = UITapGestureRecognizer(target: self, action: Selector("prevSearchTapped:"))
        tap.numberOfTapsRequired = 1
        cell.addGestureRecognizer(tap)
        // Unselect "User interaction" for Label and ContenView
        // Otherwise last element in the list is not clickable
        return cell
    }
    

    func prevSearchTapped(sender: UITapGestureRecognizer){
        if let cell = sender.view as? UITableViewCell {
            self.navigationController?.tabBarController?.selectedIndex = 0
            let ttvc = self.navigationController?.tabBarController?.viewControllers![0].topViewController as? TweetTableViewController
            ttvc?.searchText = cell.textLabel?.text
        }
        
    }

}
