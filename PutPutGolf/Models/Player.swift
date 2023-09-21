//
//  Player.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import UIKit

class Player: Codable, Identifiable {
    var id = UUID()
    var name: String
    var imageData: Data?
    var scores: [Int] = []
    var challengeScores: [Int] = []
    
    init(name: String) {
        self.name = name
    }
    
    func total() -> Int {
        return scores.reduce(0, +)
    }
    
    func finalTotal() -> Int {
        return challengeScores.reduce(total(), +)
    }

    func getImage() -> UIImage {
        guard let imgData = self.imageData, let image = UIImage(data: imgData) else { return UIImage(systemName: "person.fill")! }
        return image
    }
    
}
