//
//  ShortcutService.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/31/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

struct ShortcutService {
    static let leaderboardItem = "leaderboard"
    
    static var item: String?

    static func isValidItem(_ item: String) -> Bool {
        var isValidItem = false
        
        if item == leaderboardItem {
            self.item = item
            isValidItem = true
        }
        
        return isValidItem
    }
}
