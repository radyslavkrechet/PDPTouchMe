//
//  TabBarController.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/31/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import TouchMeKit

class TabBarController: UITabBarController {
    private enum TabBarItem: Int {
        case touch, leaderboard
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotifications()
        openScreenIfNeeded()
    }
    
    // MARK: - Configuration
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    @objc func applicationDidBecomeActive() {
        openScreenIfNeeded()
    }
    
    private func openScreenIfNeeded() {
        openBySchemeIfNeeded()
        openByShortcutIfNeeded()
    }
    
    private func openBySchemeIfNeeded() {
        if let path = SchemeService.path {
            if path == SchemeService.profilePath {
                if selectedIndex == TabBarItem.leaderboard.rawValue {
                    selectedIndex = TabBarItem.touch.rawValue
                }
                
                let navigationController = viewControllers!.first! as! UINavigationController
                
                if !(navigationController.viewControllers.last! is ProfileViewController) {
                    let touchViewController = navigationController.viewControllers.first! as! TouchViewController
                    touchViewController.performSegue(withIdentifier: Constants.SegueIdentifiers.toProfile, sender: self)
                }
            }
            
            SchemeService.path = nil
        }
    }
    
    private func openByShortcutIfNeeded() {
        if let item = ShortcutService.item {
            if item == ShortcutService.leaderboardItem {
                if selectedIndex != TabBarItem.leaderboard.rawValue {
                    selectedIndex = TabBarItem.leaderboard.rawValue
                } else {
                    let navigationController = viewControllers!.last! as! UINavigationController
                    
                    if navigationController.viewControllers.last! is ProfileViewController {
                        navigationController.popViewController(animated: false)
                    }
                }
            }
            
            ShortcutService.item = nil
        }
    }
}
