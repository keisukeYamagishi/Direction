//
//  AppDelegate.swift
//  Direction
//
//  Created by Shichimitoucarashi on 2017/12/15.
//  Copyright © 2017年 keisuke yamagishi. All rights reserved.
//

import UIKit
import GoogleMaps
//import Direction

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        APIKEY = "AIzaSyC0hOi1H3H-GorTbUIG8Ttoy4jDua5Vcd4"
        GMSServices.provideAPIKey("AIzaSyC0hOi1H3H-GorTbUIG8Ttoy4jDua5Vcd4")
        // Override point for customization after application launch.
        return true
    }
}
