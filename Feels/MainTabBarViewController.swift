//
//  MainTabBarViewController.swift
//  Feels
//
//  Created by Daniel Christopher on 10/29/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    let notificationsService = NotificationsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        for item in tabBar.items! {
            item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        item.badgeValue = nil
        
        if tabBar.items?.index(of: item) == 1 {
            notificationsService.clearUnread()
        }
    }
}
