//
//  Player.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import SwiftUI

class Player: Codable, Equatable, Hashable, Comparable, Identifiable {
    var id = UUID()
    var name: String
    var color: Color = Color.clear
    var imageData: Data?
    var scores: [String] = [] // used only for current/resuming a game
    var challengeScores: [String] = [] // used only for current/resuming a game
    var savedScoreCards: [ScoreCard] = []

    
    init(name: String, course: Course) {
        self.name = name
        scores = Array(repeating: "", count: course.holes.count)
        challengeScores = Array(repeating: "", count: course.challenges.count)
    }
    
    init(name: String, image: UIImage?, course: Course) {
        self.name = name
        self.imageData = image?.jpegData(compressionQuality: 1)
        scores = Array(repeating: "", count: course.holes.count)
        challengeScores = Array(repeating: "", count: course.challenges.count)
    }
    

    func getImage() -> UIImage {
        guard let imgData = self.imageData, let image = UIImage(data: imgData) else { return UIImage(systemName: "person.fill")! }
        return image
    }
    
    
    
    var total: String {
        let scores: [String] = scores.map({ $0 })
        return scores.reduce("", +)
    }
    
    
    var finalTotal: String {
        var scores: [String] = scores.map({ $0 })
        let chal: [String] = challengeScores.map({ $0 })
        let tot: [String] = scores + chal
        return tot.reduce("", +)
    }
    
    
    
    
    
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(color)
        hasher.combine(imageData)
    }
    
    // Equatable
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.color == rhs.color &&
        lhs.imageData == rhs.imageData
    }
    
    // Comparable
    static func < (lhs: Player, rhs: Player) -> Bool {
        return lhs.id < rhs.id &&
        lhs.name < rhs.name
    }
    
}
