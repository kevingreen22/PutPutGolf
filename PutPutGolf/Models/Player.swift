//
//  Player.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import SwiftUI

protocol PlayerProtocol {
    var id: String { get set }
    var name: String { get set }
    var scores: [String] { get set }
}

// MARK: Player
class Player: PlayerProtocol, Codable, Equatable, Hashable, Comparable, Identifiable {
    var id: String
    var name: String
    var color: Color
    var imageData: Data?
    var scores: [String]
    var challengeScores: [String]
    
    init(id: String, name: String, color: Color = .gray, course: Course) {
        self.id = id
        self.name = name
        self.color = color
        scores = Array(repeating: "0", count: course.holes.count)
        if course.challenges != nil {
            challengeScores = Array(repeating: "0", count: course.challenges!.count)
        } else {
            challengeScores = []
        }
    }
    
    init(id: String, name: String, image: UIImage?, color: Color = .gray, course: Course) {
        self.id = id
        self.name = name
        self.color = color
        self.imageData = image?.jpegData(compressionQuality: 1)
        scores = Array(repeating: "0", count: course.holes.count)
        if course.challenges != nil {
            challengeScores = Array(repeating: "0", count: course.challenges!.count)
        } else {
            challengeScores = []
        }
    }
    
    init(id: String, name: String, color: Color = .gray) {
        self.id = id
        self.name = name
        self.color = color
        scores = []
        challengeScores = []
    }
    
    
    /// Returns the image of the Player saved, otherwise a generic image to use.
    func getUIImage() -> UIImage {
        guard let imgData = self.imageData, let image = UIImage(data: imgData) else { return UIImage(systemName: "person.fill")! }
        return image
    }
    
    /// Calculates and returns the sum of scores and callengeScores of a Player.
    func totalScore() -> Int {
        var finalTotal = 0
        finalTotal = self.scores.reduce(0) { partialResult, score in
            partialResult + (Int(score) ?? 0)
        }
        
        finalTotal += self.challengeScores.reduce(0, { partialResult, score in
            partialResult + (Int(score) ?? 0)
        })
        
        return finalTotal
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


// MARK: NewPlayer
struct NewPlayer: Hashable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var image: UIImage?
    var color: Color
    
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(image)
        hasher.combine(color)
    }
}


// MARK: QuickPlayer
class QuickPlayer: PlayerProtocol, Codable, Equatable, Hashable, Comparable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var scores: [String]
    
    init(name: String) {
        self.name = name
        self.scores = []
    }
    
/// Calculates and returns the sum of all scores of a QuickPlayer.
    func totalScore() -> Int {
        return self.scores.reduce(0) { partialResult, score in
            partialResult + (Int(score) ?? 0)
        }
    }
    
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    
    // Equatable
    static func == (lhs: QuickPlayer, rhs: QuickPlayer) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name
    }
    
    // Comparable
    static func < (lhs: QuickPlayer, rhs: QuickPlayer) -> Bool {
        return lhs.id < rhs.id &&
        lhs.name < rhs.name
    }
    
}




extension Array where Array.Element == QuickPlayer {
    
    func asPlayerType() -> [Player]  {
        var players = [Player]()
        
        for i in 0..<self.count {
            let player = Player(id: self[i].id, name: self[i].name)
            players.append(player)
        }
        return players
    }
}
    

