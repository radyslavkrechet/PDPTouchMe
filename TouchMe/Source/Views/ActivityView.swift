//
//  ActivityView.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/26/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

typealias ActivityCompletion = () -> Void

class ActivityView: UIView {
    private static let duration = 0.3
    
    private static var hud: ActivityView!
    
    // MARK: - Lifecycle
    
    private init() {
        let frame = UIApplication.shared.delegate!.window!!.frame
        super.init(frame: frame)
        
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
 
    // MARK: - Configuretion
    
    private func configure() {
        backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        alpha = 0.0
        
        addIndicator()
    }
    
    private func addIndicator() {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.center = UIApplication.shared.windows.first!.center
        indicator.startAnimating()
        addSubview(indicator)
    }
    
    static func show(_ completion: @escaping ActivityCompletion) {
        guard hud == nil else {
            return
        }
        
        hud = ActivityView()
        UIApplication.shared.delegate!.window!!.addSubview(hud)
        
        UIView.animate(withDuration: duration, animations: { 
            hud.alpha = 1.0
        }) { success in
            completion()
        }
    }
    
    static func hide(_ completion: @escaping ActivityCompletion) {
        UIView.animate(withDuration: duration, animations: {
            hud.alpha = 0.0
        }) { success in
            hud.removeFromSuperview()
            hud = nil
            
            completion()
        }
    }
}
