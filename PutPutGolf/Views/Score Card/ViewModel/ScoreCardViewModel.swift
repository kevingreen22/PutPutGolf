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
    @Published var players: [Player]
    @Published var totals: [Int] = []
    @Published var finalTotals: [Int] = []
    var cancellables: Set<AnyCancellable> = []
    
    init(course: Course, players: [Player], isResumingGame: Bool = false) {
        self.course = course
        self.players = players
        initScoresArray(isResumingGame: isResumingGame)
        subscribe()
    }
    
    
    /// Inits scores with the proper size of array and/or scores of current game.
    func initScoresArray(isResumingGame: Bool) {
        if isResumingGame {
            for player in players {
                let total = Int(player.scores.map({ Int($0) ?? 0 }).reduce(0, +))
                let challenges = Int(player.challengeScores.map({ Int($0) ?? 0 }).reduce(0, +))
                totals.append(total)
                finalTotals.append(total + challenges)
            }
        } else {
            for player in players {
                player.scores = Array(repeating: "", count: course.holes.count + course.challenges.count)
                totals.append(0)
                finalTotals.append(0)
            }
        }
        print("init totals: \(totals)")
        print("init finals: \(finalTotals)")
    }
    
    
    func subscribe() {
        $players
            .sink { [weak self] players in
                guard let self = self else { return }
                for (i,player) in players.enumerated() {
                    let total = Int(player.scores.map({ Int($0) ?? 0 }).reduce(0, +))
                    let challenges = Int(player.challengeScores.map({ Int($0) ?? 0 }).reduce(0, +))
                    self.totals[i] = total
                    self.finalTotals[i] = total + challenges
                    print("subscibed.totals: \(String(describing: self.totals))")
                    print("subscibed.finals: \(String(describing: self.finalTotals))")
                }
            }
            .store(in: &cancellables)
    }
    
    
    
//    func getPlayerIndex(_ player: Player) -> Int {
//        guard let player = players.firstIndex(of: player) else { return 0 }
//        return player
//    }
//    
//    
//    func challengeScoreFor(_ challengeScoreIndex: Int, playerIndex: Int) -> String {
//        return playerScores[playerIndex][challengeScoreIndex]
//    }
//    
//    
//    func totalScoreFor(playerIndex: Int) -> String {
//        let player = playerScores[playerIndex]
//        let lastIndex = player.index(before: player.endIndex-2)
//        return player[lastIndex]
//    }
//    
//    
//    func finalScoreFor(playerIndex: Int) -> String {
//        let player = playerScores[playerIndex]
//        let lastIndex = player.index(before: player.endIndex-2)
//        return player[lastIndex]
//    }
//    
//    
//    /// Updates the score for a player for the specific hole.
//    /// - Parameters:
//    ///   - score: An Int to insert into the scores array for a player.
//    ///   - playerIndex: The index of the player.
//    ///   - holeIndex: The index of the hole.
//    func update(_ score: String, playerIndex: Int, holeIndex: Int) {
//        playerScores[playerIndex][holeIndex] = score
//        updateTotalfor(playerIndex: playerIndex)
//        print("\(type(of: self)).\(#function) - \(playerScores)")
//    }
//    
//    
//    /// Updates the Total score for a player.
//    /// - Parameter playerIndex: The index of the player.
//    fileprivate func updateTotalfor(playerIndex: Int) {
//        let totalholesCount = course.holes.count
//        var total = 0
//        for (i,score) in playerScores[playerIndex].enumerated() {
//            if let scr = Int(score), i+1 < totalholesCount {
//                total += scr
//            }
//        }
//        playerScores[playerIndex][totalholesCount + course.challenges.count] = String(total)
//        print("updated total score: \(total)")
//        updateFinalTotalFor(playerIndex: playerIndex)
//    }
//    
//    
//    /// Updates the Final Total score for a player.
//    /// - Parameter playerIndex: The index of the player.
//    fileprivate func updateFinalTotalFor(playerIndex: Int) {
//        let totalholesWChallengesCount = course.holes.count + course.challenges.count + 1
//        var total = 0
//        for (i,score) in playerScores[playerIndex].enumerated() {
//            if let scr = Int(score), i+1 < totalholesWChallengesCount {
//                total += scr
//            }
//        }
//        playerScores[playerIndex][totalholesWChallengesCount] = String(total)
//        print("updated final total score: \(total)")
//    }
    
    
}

