//
//  LocalAuthenticationService.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/22/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation
import LocalAuthentication

typealias BiometricsAuthenticationCompletion = (_ success: Bool,
    _ policyError: NSError?,
    _ authenticationError: LAError?) -> Void

struct AuthenticationService {
    static var canAuthenticateWithBiometrics: Bool {
        var error: NSError?
        LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return error == nil
    }
    
    static func authenticateWithBiometrics(withLocalizedReason localizedReason: String,
                                           _ completion: @escaping BiometricsAuthenticationCompletion) {
        
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false, error, nil)
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: localizedReason) { success, error in
                                
                                DispatchQueue.main.async {
                                    guard !success,
                                        let error = error as? LAError else {
                                            
                                            completion(true, nil, nil)
                                            return
                                    }
                                    
                                    completion(false, nil, error)
                                }
        }
    }
}
