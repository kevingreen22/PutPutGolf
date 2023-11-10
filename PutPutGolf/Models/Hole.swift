//
//  Hole.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import Foundation
import SwiftUI

struct Hole: Codable, Hashable, Equatable, Identifiable {
    var id: String
    var number: Int
    var par: Int
    var difficulty: Difficulty
    
    init(id: String, number: Int, par: Int, difficulty: Difficulty) {
        self.id = id
        self.number = number
        self.par = par
        self.difficulty = difficulty
    }
}


enum Difficulty: String, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case veryHard = "Very Hard"
    
    static func icon(_ difficulty: Difficulty) -> Image {
        switch difficulty {
        case .easy:
            Image(systemName: "circle.circle.fill")
        case .medium:
            Image(systemName: "square.circle.fill")
        case .hard:
            Image(systemName: "triangle.circle.fill")
        case .veryHard:
            Image(systemName: "diamond.circle.fill")
        }
    }
    
    static func color(for difficulty: Difficulty) -> Color {
        switch difficulty {
        case .easy: Color.green
        case .medium: Color.blue
        case .hard: Color.red
        case .veryHard: Color.black
        }
    }

}
