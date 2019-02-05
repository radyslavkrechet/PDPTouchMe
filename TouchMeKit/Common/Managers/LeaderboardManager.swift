//
//  LeaderboardManager.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/26/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public class LeaderboardManager {
    public static let shared = LeaderboardManager()
    
    public private(set) var leaderboard = [[String: Any]]()
    
    public func updateLeaderboard(_ leaderboard: [[String: Any]]) {
        self.leaderboard = leaderboard
        self.leaderboard.sort { $0["score"] as! Int > $1["score"] as! Int }
        
        DatabaseManager.shared.updateScore(self.scoreOfGamer(withEmail: SessionService.email!))
        DatabaseManager.shared.updatePosition(self.positionOfGamer(withEmail: SessionService.email!))
    }
    
    public func positionOfGamer(withEmail email: String) -> Int {
        for position in stride(from: 0, to: leaderboard.count, by: 1) {
            let gamer = leaderboard[position]
            if gamer["email"] as! String == email {
                return position + 1
            }
        }
        
        return 0
    }
    
    public func scoreOfGamer(withEmail email: String) -> Int {
        for gamer in leaderboard {
            if gamer["email"] as! String == email {
                return gamer["score"] as! Int
            }
        }
        
        return 0
    }
}
