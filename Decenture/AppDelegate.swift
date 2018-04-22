//
//  AppDelegate.swift
//  Decenture
//
//  Created by Nathan Dane on 21/04/2018.
//  Copyright © 2018 Blockchainers. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let navigationController =  UINavigationController(rootViewController: TransactionHistoryViewController())
    navigationController.isNavigationBarHidden = true

    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    return true
  }

}
