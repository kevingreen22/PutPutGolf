//
//  Challenge.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import Foundation

struct Challenge: Codable, Hashable, Equatable, Identifiable {
    var id: String
    var name: String
    var rules: String
    var difficulty: Difficulty
    
    init(id: String, name: String, rules: String, difficulty: Difficulty) {
        self.id = id
        self.name = name
        self.rules = rules
        self.difficulty = difficulty
    }
}
