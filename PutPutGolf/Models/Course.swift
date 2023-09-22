//
//  Courses.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import Foundation

struct Course: Codable, Identifiable {
    var id = UUID()
    var name: String
    var location: String
    var difficulty: Difficulty
    var holes: [Hole]
    var challenges: [Challenge]
    
    func totalPar() -> Int {
        var totalPar = 0
        for hole in holes {
            totalPar += hole.par
        }
        return totalPar
    }
}
