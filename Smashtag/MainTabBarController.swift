//
//  MainTabBarController.swift
//  Smashtag
//
//  Created by Jose Luis Lucini Reviriego on 13/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

protocol UserSavedData {
    
    func storeSearch(search: String)
    
    func retrieveHistory() -> [String]
    
    func doSearch(search: String)
    
}

class MainTabBarController: UITabBarController, UITabBarControllerDelegate, UserSavedData{
   
    // MARK: - UserSavedData
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    private var history = [String]()
    
    func storeSearch(search: String){
        let ix = find(history, search)
        if ix == nil {
            history.append(search)
            if history.count > 100 {
                history.removeLast()
            }
            defaults.setObject(history, forKey: "SavedArray")
        }
    }
    
    func retrieveHistory() -> [String] {
        return history
    }
    
    func doSearch(search: String) {
        self.selectedIndex = 0
        let ttvc = self.viewControllers![0].topViewController as? TweetTableViewController
        ttvc?.searchText = search
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.history = defaults.objectForKey("SavedArray") as? [String] ?? [String]()
        if let ttvc = self.viewControllers![0].topViewController as? TweetTableViewController {
            ttvc.userHistory = self
        }
        if let htvc = self.viewControllers![1].topViewController as? HistoryTableViewController {
            htvc.userHistory = self
        }
    }
    
}
