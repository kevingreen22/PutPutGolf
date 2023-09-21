//
//  Hole.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import Foundation

struct Hole: Codable, Identifiable {
    var id = UUID()
    var number: Int
    var par: Int
    var difficulty: Difficulty
}


enum Difficulty: Codable {
    case easy
    case medium
    case hard
    case veryHard
}
