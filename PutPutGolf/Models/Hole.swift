//
//  Hole.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import Foundation

struct Hole: Codable, Hashable, Equatable, Identifiable {
    var id = UUID()
    var number: Int
    var par: Int
    var difficulty: Difficulty
}


enum Difficulty: String, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case veryHard = "Very Hard"
}
