//
//  ScoreCardViewModel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/21/23.
//

import SwiftUI
import Combine

class ScoreCardViewModel: ObservableObject {
    var course: Course
    var players: [Player]
    var isResumingGame: Bool = false
    @Published var scores: [[String]] = [[]]
    var cancellables: Set<AnyCancellable> = []
    
    init(course: Course, players: [Player], isResumingGame: Bool = false) {
        self.course = course
        self.players = players
        
        // inits scores with the proper size of array
        // For new game.
        self.scores = Array(repeating: [], count: players.count)
        for i in players.indices {
            scores[i] = Array(repeating: "", count: course.holes.count + course.challenges.count)
        }
            
        if isResumingGame {
            for (i,player) in players.enumerated() {
                for (j,score) in player.scores.enumerated() {
                    scores[i][j] = score
                }
            }
        }
        
    }
    
}

