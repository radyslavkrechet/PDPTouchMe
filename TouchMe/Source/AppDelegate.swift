//
//  AppDelegate.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/22/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import TouchMeKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseService.configure()
        
        return true
    }
    
    private func application(_ app: UIApplication, open url: URL,
                             options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return SchemeService.isValidUrl(url)
    }
    
    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        
        completionHandler(ShortcutService.isValidItem(shortcutItem.type))
    }
}
