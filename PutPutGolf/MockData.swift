//
//  MockData.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import Foundation

class MockData {
    
    static var shared = MockData()
    
    var courses: [Course] = []
    
    var players: [Player] = [
        Player(name: "Kevin"),
        Player(name: "Nell"),
        Player(name: "Holly"),
        Player(name: "Whitney")
    ]
    
    private init() {        
        let holes = [
            Hole(number: 1, par: 2, difficulty: .medium),
            Hole(number: 2, par: 3, difficulty: .hard),
            Hole(number: 3, par: 3, difficulty: .easy),
            Hole(number: 4, par: 4, difficulty: .easy),
            Hole(number: 5, par: 2, difficulty: .medium),
            Hole(number: 6, par: 3, difficulty: .medium),
            Hole(number: 7, par: 1, difficulty: .medium),
            Hole(number: 8, par: 3, difficulty: .hard),
            Hole(number: 9, par: 1, difficulty: .medium),
            Hole(number: 10, par: 4, difficulty: .medium),
            Hole(number: 11, par: 3, difficulty: .veryHard),
            Hole(number: 12, par: 2, difficulty: .medium),
            Hole(number: 13, par: 2, difficulty: .medium),
            Hole(number: 14, par: 2, difficulty: .medium),
            Hole(number: 15, par: 2, difficulty: .medium),
            Hole(number: 16, par: 2, difficulty: .medium),
            Hole(number: 17, par: 2, difficulty: .medium),
            Hole(number: 18, par: 1, difficulty: .medium),
            Hole(number: 19, par: 2, difficulty: .medium),
            Hole(number: 20, par: 2, difficulty: .medium),
            Hole(number: 21, par: 1, difficulty: .medium)
        ]
        
        let challenges = [
            Challenge(name: "Time Trial", rules: "there are the rules for time trials", difficulty: .easy),
            Challenge(name: "Closest To the Hole", rules: "there are the rules for time trials", difficulty: .medium),
            Challenge(name: "First In wins.", rules: "there are the rules for time trials", difficulty: .hard),
        ]
        
        courses.append(
            Course(name: "Goat Track Country Club", location: "Walnut Creek", holes: holes, challenges: challenges)
        )
        
        for player in players {
            for _ in 0..<21 {
                player.scores.append(Int.random(in: 1...5))
            }
            
            for _ in 0..<3 {
                player.challengeScores.append(Int.random(in: 1...5))
            }
            
            print(player.name)
            print(player.scores)
            print(player.challengeScores)
        }
        
        
        
    }
    
    
}
