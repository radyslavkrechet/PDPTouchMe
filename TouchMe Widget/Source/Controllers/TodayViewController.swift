//
//  TodayViewController.swift
//  TouchMe Widget
//
//  Created by Radislav Crechet on 5/26/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import NotificationCenter
import TouchMeKit

class TodayViewController: UIViewController {
    @IBOutlet var avatarLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGamer()
    }
    
    // MARK: - Configuration
    
    private func configureGamer() {
        guard SessionService.haveSession else {
            return
        }
        
        let gamer = DatabaseManager.shared.gamer()!
        avatarLabel.text = String(gamer.email.first!)
        emailLabel.text = gamer.email
        scoreLabel.text = String(gamer.score)
        positionLabel.text = String(gamer.position)
        
        updateLeaderboard { [unowned self] in
            let gamer = DatabaseManager.shared.gamer()!
            let position = gamer.position
            self.scoreLabel.text = String(gamer.score)
            self.positionLabel.text = position > 0 ? String(position) : "-"
        }
    }

    private func updateLeaderboard(_ completion: @escaping () -> Void) {
        NetworkService.leaderboard {
            completion()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func viewPressed(_ sender: Any) {
        extensionContext!.open(SchemeService.profileUrl, completionHandler: nil)
    }
}
