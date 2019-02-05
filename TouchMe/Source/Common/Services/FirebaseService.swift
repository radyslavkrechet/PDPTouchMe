//
//  FirebaseService.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/26/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Firebase
import TouchMeKit

public typealias Completion = () -> Void

public struct FirebaseService {
    public static func configure() {
        FirebaseApp.configure()
    }

    // MARK: - Work With Authentication
    
    public static func signUp(withEmail email: String, password: String, completion: @escaping Completion) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            DispatchQueue.main.async {
                FirebaseService.setScore {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        }
    }
    
    public static func signIn(withEmail email: String, password: String, completion: @escaping Completion) {
        Auth.auth().signIn(withEmail: email, password: password) { _, _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    // MARK: - Work With Database
    
    private static func setScore(_ completion: @escaping Completion) {
        let reference = Database.database().reference()
        let value: [String : Any] = ["email": SessionService.email!, "score": 0]
        reference.child("leaderboard").child(Auth.auth().currentUser!.uid).setValue(value) { (error, reference) in
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    public static func updateScore(_ score: Int) {
        let reference = Database.database().reference()
        let value: [String : Any] = ["email": SessionService.email!, "score": score]
        let childUpdates = ["/leaderboard/\(Auth.auth().currentUser!.uid)/": value]
        reference.updateChildValues(childUpdates)
    }
}
