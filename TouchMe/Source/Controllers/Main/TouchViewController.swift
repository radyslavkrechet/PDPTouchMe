//
//  TouchViewController.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/25/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import TouchMeKit

class TouchViewController: UIViewController {
    @IBOutlet var touchButton: UIButton!
    @IBOutlet var scoreLabel: UILabel!

    private var titles = [String]()
    private var index = 0
    private var score = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotifications()
        loadTitles()
        updateTouchButtonTitle()
        configureScore()
        setLeaderboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateScore()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var score = DatabaseManager.shared.gamer()!.score

        if self.score > score {
            score = self.score
        }

        let profileViewController = segue.destination as! ProfileViewController
        profileViewController.gamer = ["email": SessionService.email!, "score": score]
    }
    
    // MARK: - Configuration
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    @objc func applicationWillResignActive() {
        updateScore()
    }
    
    private func loadTitles() {
        guard let path = Bundle.main.path(forResource: "Titles", ofType: "plist"),
            let contents = NSDictionary(contentsOfFile: path) as? [String: Any],
            let titles = contents["Titles"] as? [String] else {
                
                return
        }
        
        self.titles = titles
    }
    
    private func configureScore() {
        let gamer = DatabaseManager.shared.gamer()!
        scoreLabel.text = String(gamer.score)
        score = gamer.score
    }
    
    private func updateTouchButtonTitle() {
        touchButton.setTitle(titles[index], for: .normal)
    }
    
    private func updateScoreLabelText() {
        scoreLabel.text = String(score)
    }

    // MARK: - Actions
    
    @IBAction func touchButtonPressed(_ sender: Any) {
        index += 1
        score += 1
        
        if titles.count <= index {
            index = 0
        }
        
        updateTouchButtonTitle()
        updateScoreLabelText()
    }

    // MARK: - Work With Score
    
    fileprivate func updateScore() {
        DatabaseManager.shared.updateScore(score)
        FirebaseService.updateScore(score)
    }

    // MARK: - Work With Leaderboard
    
    fileprivate func setLeaderboard() {
        NetworkService.leaderboard {}
    }
}
