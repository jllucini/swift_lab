//
//  MainTabBarController.swift
//  Smashtag
//
//  Created by Jose Luis Lucini Reviriego on 13/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    // MARK: - Navigation
    
    func tabBarController(tabBarController: UITabBarController,
        didSelectViewController viewController: UIViewController){
            println("Tab \(viewController)")
    }
    
}
