//
//  Player.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import UIKit

class Player: Codable, Equatable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var imageData: Data?
    var scores: [String] = []
    var challengeScores: [String] = []
    var savedScoreCards: [ScoreCard] = []
    
    init(name: String, course: Course) {
        self.name = name
        scores = Array(repeating: "", count: course.holes.count)
        challengeScores = Array(repeating: "", count: course.challenges.count)
    }
    
    func total() -> Int {
        var total = 0
        for score in scores {
            if let scr = Int(score) {
                total += scr
            }
        }
        return total
    }
    
    func finalTotal() -> Int {
        var total = 0
        for score in challengeScores {
            if let scr = Int(score) {
                total += scr
            }
        }
        return total
    }

    func getImage() -> UIImage {
        guard let imgData = self.imageData, let image = UIImage(data: imgData) else { return UIImage(systemName: "person.fill")! }
        return image
    }
    
    func score(for hole: Hole) -> String? {
        return self.scores[hole.number-1]
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(imageData)
        hasher.combine(scores)
        hasher.combine(challengeScores)
        hasher.combine(savedScoreCards)
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.imageData == rhs.imageData &&
        lhs.scores == rhs.scores &&
        lhs.challengeScores == rhs.challengeScores &&
        lhs.savedScoreCards == rhs.savedScoreCards
    }
    
}
