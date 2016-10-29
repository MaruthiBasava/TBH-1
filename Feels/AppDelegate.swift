//
//  AppDelegate.swift
//  Feels
//
//  Created by Daniel Christopher on 10/16/16.
//  Copyright © 2016 IcyPickups LLC. All rights reserved.
//

import UIKit
import Fabric
import DigitsKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Digits.self])
        
        let pageControlAppearance = UIPageControl.appearance()
        pageControlAppearance.pageIndicatorTintColor = UIColor.basavaRed().withAlphaComponent(0.75)
        pageControlAppearance.currentPageIndicatorTintColor = UIColor.basavaRed()
        
        UITabBar.appearance().tintColor = UIColor.basavaRed()
        
        let authService = AuthService()
        
        if authService.isAuthenticated() {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = mainStoryboard.instantiateInitialViewController()
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = mainViewController
            self.window?.makeKeyAndVisible()
        }
        else {
            let introStoryboard = UIStoryboard(name: "Intro", bundle: nil)
            let introViewController = introStoryboard.instantiateInitialViewController()
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = introViewController
            self.window?.makeKeyAndVisible()
        }
        
        let attr = [NSFontAttributeName: UIFont(name: "WorkSans-Regular", size: 17.0)!]
        UISegmentedControl.appearance().setTitleTextAttributes(attr, for: .normal)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

