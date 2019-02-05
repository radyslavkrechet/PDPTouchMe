//
//  ProfileViewController.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/26/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import TouchMeKit

class ProfileViewController: UIViewController {
    @IBOutlet var avatarLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!

    override var previewActionItems: [UIPreviewActionItem] {
        let shareAction = UIPreviewAction(title: "Share", style: .default) { _, _ in
            self.leaderboardViewController.present(self.activityViewController, animated: true)
        }
        
        return [shareAction]
    }
    
    private var activityViewController: UIActivityViewController {
        let item = "\(gamer["email"]!) get \(gamer["score"]!) at TouchMe. Can you beat it?"
        
        return UIActivityViewController(activityItems: [item], applicationActivities: nil)
    }
    
    var leaderboardViewController: LeaderboardViewController!
    var gamer: [String: Any]!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureGamer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateLeaderboard()
    }
    
    // MARK: - Configuration
    
    fileprivate func configureGamer() {
        let email = gamer["email"] as! String
        var position: Int!
        
        if email == SessionService.email! {
            position = DatabaseManager.shared.gamer()!.position
        } else {
            position = LeaderboardManager.shared.positionOfGamer(withEmail: email)
        }
        
        avatarLabel.text = String(email.first!)
        emailLabel.text = email
        scoreLabel.text = String(gamer["score"] as! Int)
        positionLabel.text = position > 0 ? String(position) : "-"
    }
    
    // MARK: - Actions
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        present(activityViewController, animated: true, completion: nil)
    }

    // MARK: - Work With Leaderboard
    
    private func updateLeaderboard() {
        NetworkService.leaderboard { [weak self] in
            self?.configureGamer()
        }
    }
}
