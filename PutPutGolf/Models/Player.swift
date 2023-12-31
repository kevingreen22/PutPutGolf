//
//  Player.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import SwiftUI

class Player: Codable, Equatable, Hashable, Comparable, Identifiable {
    var id: String
    var name: String
    var color: Color
    var imageData: Data?
    var scores: [String] // used only for current/resuming a game
    var challengeScores: [String] // used only for current/resuming a game
    
    init(id: String, name: String, color: Color = .gray, course: Course) {
        self.id = id
        self.name = name
        self.color = color
        scores = Array(repeating: "", count: course.holes.count)
        challengeScores = Array(repeating: "", count: course.challenges.count)
    }
    
    init(id: String, name: String, image: UIImage?, color: Color = .gray, course: Course) {
        self.id = id
        self.name = name
        self.color = color
        self.imageData = image?.jpegData(compressionQuality: 1)
        scores = Array(repeating: "", count: course.holes.count)
        challengeScores = Array(repeating: "", count: course.challenges.count)
    }
    

    func getImage() -> UIImage {
        guard let imgData = self.imageData, let image = UIImage(data: imgData) else { return UIImage(systemName: "person.fill")! }
        return image
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
