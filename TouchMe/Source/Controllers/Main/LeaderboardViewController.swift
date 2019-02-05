//
//  LeaderboardViewController.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/26/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import TouchMeKit

class LeaderboardViewController: UITableViewController, UIViewControllerPreviewingDelegate {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerPreviewwingIfAvailable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateLeaderboard()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let profileViewController = segue.destination as! ProfileViewController
        profileViewController.gamer = LeaderboardManager.shared.leaderboard[tableView.indexPathForSelectedRow!.row]
    }
    
    // MARK: - Configuration
    
    private func registerPreviewwingIfAvailable() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
    }

    // MARK: - Work With Leaderboard
    
    fileprivate func updateLeaderboard() {
        NetworkService.leaderboard { [unowned self] in
            self.tableView.reloadData()
        }
    }

    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LeaderboardManager.shared.leaderboard.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let position = indexPath.row + 1
        let gamer = LeaderboardManager.shared.leaderboard[indexPath.row]
        let email = gamer["email"] as! String
        var text = "\(position). \(email)"
        
        if email == SessionService.email! {
            text += " (you)"
            cell.textLabel!.textColor = tabBarController!.tabBar.tintColor
        } else {
            cell.textLabel!.textColor = UIColor.black
        }
        
        cell.textLabel!.text = text
        
        return cell
    }

    // MARK: - UITableViewDataSource

    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else {
                
                return nil
        }
        
        previewingContext.sourceRect = cell.frame
        
        let identifier = Constants.ViewControllerIdentifiers.profileViewController
        let viewController = storyboard!.instantiateViewController(withIdentifier: identifier)
        let profileViewController = viewController as! ProfileViewController
        profileViewController.preferredContentSize = CGSize(width: view.frame.size.width, height: 92.0)
        profileViewController.leaderboardViewController = self
        profileViewController.gamer = LeaderboardManager.shared.leaderboard[indexPath.row]
        
        return profileViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
    }
}
