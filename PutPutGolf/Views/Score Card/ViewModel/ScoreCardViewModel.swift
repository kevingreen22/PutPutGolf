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
    @FocusState var focusScoreBox
    
    init(course: Course, players: [Player], isResumingGame: Bool = false) {
        self.course = course
        self.players = players
        
        initScoresArray()
    }
    
    
    /// Inits scores with the proper size of array.
    func initScoresArray() {
        // For new game.
        self.scores = Array(repeating: Array(repeating: "", count: course.holes.count + course.challenges.count), count: players.count)
        print("\(type(of: self)).\(#function).scores: \(scores)")

        if isResumingGame {
            for (i,player) in players.enumerated() {
                for (j,score) in player.scores.enumerated() {
                    scores[i][j] = score
                }
            }
        }
    }
    
    func update(_ score: String, playerIndex: Int, holeIndex: Int) {
        print("playerIndex: \(playerIndex)")
        print("holeIndex: \(holeIndex)")
        scores[playerIndex][holeIndex] = score
        print("\(type(of: self)).\(#function).scores: \(scores)")
    }
    
}

