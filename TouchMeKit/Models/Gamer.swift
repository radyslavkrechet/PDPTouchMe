//
//  Gamer.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/26/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import RealmSwift

public class Gamer: Object {
    @objc public dynamic var email = ""
    @objc public dynamic var score = 0
    @objc public dynamic var position = 0
}
