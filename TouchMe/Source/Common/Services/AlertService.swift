//
//  AlertService.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/22/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

struct AlertService {
    static let errorAlertTitle = "Error"
    static let okActionTitle = "OK"

    static func errorAlert(withMessage message: String) -> UIAlertController {
        let errorAlert = UIAlertController(title: errorAlertTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: nil)
        errorAlert.addAction(okAction)
        return errorAlert
    }
}
