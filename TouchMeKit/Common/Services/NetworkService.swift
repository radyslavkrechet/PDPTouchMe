//
//  NetworkService.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/30/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

let projectId = "touchme-8f8ab"

public typealias Completion = () -> Void

public struct NetworkService {
    public static func leaderboard(_ completion: @escaping Completion) {
        let leaderboardUrl = URL(string: "https://\(projectId).firebaseio.com/leaderboard.json?print=pretty")!
        let request = URLRequest(url: leaderboardUrl)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, _ in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        
                        completion()
                        return
                }
                
                let json = try! JSONSerialization.jsonObject(with: data!) as! [String: Any]
                let leaderboard = json.map { $0.value as! [String: Any] }
                
                LeaderboardManager.shared.updateLeaderboard(leaderboard)
                
                completion()
            }
        }
        
        task.resume()
    }
}
