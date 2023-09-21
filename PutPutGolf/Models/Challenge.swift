//
//  Challenge.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import Foundation

struct Challenge: Codable, Identifiable {
    var id = UUID()
    var name: String
    var rules: String
    var difficulty: Difficulty
}
