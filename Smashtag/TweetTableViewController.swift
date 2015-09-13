//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Jose Luis Lucini Reviriego on 7/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    // The model !
    var tweets = [[Tweet]]()
    
    // The API
    var searchText: String? = "#stanford" {
        didSet {
            lastSuccessfulRequest = nil
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
            if searchText != nil {
                storeSearch(searchText!)
            }
        }
    }

    // MARK: - View Controler LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    var lastSuccessfulRequest: TwitterRequest?
    
    var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil{
            if searchText != nil{
                return TwitterRequest(search: searchText!, count: 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    func refresh(){
        if refreshControl != nil{
            refreshControl!.beginRefreshing()
        }
        refreshSpinner(refreshControl)
    }
    
    // MARK: - UITextField Delegate
    

    @IBAction func refreshSpinner(sender: UIRefreshControl?) {
        if searchText != nil{
            //let request = TwitterRequest(search: searchText!, count: 100)
            if let request = nextRequestToAttempt {
                request.fetchTweets() { (newTweets) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if newTweets.count > 0 {
                            self.lastSuccessfulRequest = request
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                            sender!.endRefreshing()
                        }
                    })
                }
            }
        } else {
            sender?.endRefreshing()
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    private struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as TweetTableViewCell

        cell.tweet = tweets[indexPath.section][indexPath.row]

        return cell
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 500.0
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowMentions"{
            let ttve = sender as? TweetTableViewCell
            let mentionsAdapter = MentionsAdapter(aTweet: ttve!.tweet)
            let nav = segue.destinationViewController as UINavigationController
            let mvc = nav.topViewController as MentionsTableViewController
            mvc.mentionsAdapter = mentionsAdapter
        }
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue){
        
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    func storeSearch(search: String){
        var array = defaults.objectForKey("SavedArray") as? [String] ?? [String]()
        let ix = find(array, search)
        if ix == nil {
            array.append(search)
            if array.count > 100 {
                array.removeLast()
            }
            defaults.setObject(array, forKey: "SavedArray")
        }
    }
}
