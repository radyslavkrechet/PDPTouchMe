//
//  DatabaseManager.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/26/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import RealmSwift

public class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private var realm: Realm {
        let identifier = Constants.GroupIdentifiers.touchMe
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier)!
        let realmUrl = URL(string: url.absoluteString.appending("default.realm"))!
        var configuration = Realm.Configuration()
        configuration.fileURL = realmUrl
        Realm.Configuration.defaultConfiguration = configuration
        
        return try! Realm()
    }
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Work With Gamers
    
    public func add(_ gamer: Gamer) {
        try! realm.write {
            realm.add(gamer)
        }
    }
    
    public func gamer() -> Gamer? {
        let gamers = Array(realm.objects(Gamer.self).filter("email == '\(SessionService.email!)'"))
        return gamers.first
    }
    
    public func updateScore(_ score: Int) {
        let gamer = DatabaseManager.shared.gamer()!
        
        try! realm.write {
            gamer.score = score
        }
    }
    
    public func updatePosition(_ position: Int) {
        let gamer = DatabaseManager.shared.gamer()!
        
        try! realm.write {
            gamer.position = position
        }
    }
}
