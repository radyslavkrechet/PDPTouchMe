//
//  SchemeService.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/30/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import Foundation

public struct SchemeService {
    public static let scheme = "touchme://"
    public static let hostname = "localhost"
    public static let profilePath = "/profile"
    
    public static var path: String?
    
    public static var profileUrl: URL {
        return URL(string: scheme + hostname + profilePath)!
    }

    public static func isValidUrl(_ url: URL) -> Bool {
        var isValidUrl = false
        
        if url.path == profilePath {
            path = url.path
            isValidUrl = true
        }
        
        return isValidUrl
    }
}
