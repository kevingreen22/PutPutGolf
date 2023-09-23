//
//  Courses.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import Foundation
import MapKit

struct Course: Codable, Hashable, Equatable, Identifiable {
    var id = UUID()
    var name: String
    var location: String
    var address: String
    var difficulty: Difficulty
    var holes: [Hole]
    var challenges: [Challenge]
    var rules: [String]
    
    func totalPar() -> Int {
        var totalPar = 0
        for hole in holes {
            totalPar += hole.par
        }
        return totalPar
    }
    
    
    
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.name == rhs.name &&
        lhs.location == rhs.location &&
        lhs.address == rhs.address &&
        lhs.difficulty == rhs.difficulty &&
        lhs.holes == rhs.holes &&
        lhs.challenges == rhs.challenges &&
        lhs.rules == rhs.rules
    }
}
