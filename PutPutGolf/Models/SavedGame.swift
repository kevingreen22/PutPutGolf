//
//  SavedGame.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/28/23.
//

import Foundation

struct SavedGame: Codable, Equatable, Hashable {
    var id = UUID()
    var course: Course
    var players: [Player]
}
