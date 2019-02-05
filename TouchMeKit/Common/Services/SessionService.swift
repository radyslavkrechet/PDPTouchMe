//
//  File.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/25/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public struct SessionService {
    private static var userDefaults: UserDefaults {
        return UserDefaults(suiteName: Constants.GroupIdentifiers.touchMe)!
    }
    
    public static var haveSession: Bool {
        var haveSession = false
        
        if userDefaults.value(forKey: "email") != nil {
            haveSession = true
        }
        
        return haveSession
    }
    
    public static var email: String? {
        guard let email = userDefaults.value(forKey: "email") as? String else {
            return nil
        }
        
        return email
    }
    
    public static func setEmail(_ email: String) {
        userDefaults.setValue(email, forKey: "email")
    }
}
