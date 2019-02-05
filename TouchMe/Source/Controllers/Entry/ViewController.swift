//
//  ViewController.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/22/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import Hero

class ViewController: UIViewController {

    // MARK: - Configuration
    
    func presentErrorAlert(withMessage message: String) {
        let errorAlertController = AlertService.errorAlert(withMessage: message)
        present(errorAlertController, animated: true)
    }
    
    func presentMain() {
        let mainViewController = viewController(forStoryboardName: Constants.StoryboardNames.main)
        Hero.shared.defaultAnimation = .zoomOut
        present(mainViewController, animated: true)
    }
}
