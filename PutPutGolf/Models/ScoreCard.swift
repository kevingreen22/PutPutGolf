//
//  ScoreCard.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/28/23.
//

import Foundation

struct ScoreCard: Codable, Equatable, Hashable {
    typealias Scores = Int
    var id = UUID()
    var course: Course
    var players: [Player : [Scores]]
}
