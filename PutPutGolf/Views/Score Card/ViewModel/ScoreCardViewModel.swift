//
//  ScoreCardViewModel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/21/23.
//

import SwiftUI
import Combine

@MainActor class ScoreCardViewModel: ObservableObject {
    var course: Course
    @Published var players: [Player]
    @Published var totals: [Int] = []
    @Published var finalTotals: [Int] = []
    var cancellables: Set<AnyCancellable> = []
    @AppStorage("savedGame") var savedGameData: Data?
    
    init(course: Course, players: [Player], isResumingGame: Bool = false) {
        print("\(type(of: self)).\(#function)")
        self.course = course
        self.players = players
        initTotals(isResumingGame: isResumingGame)
//        subscribe()
    }
    
    
    /// Inits scores with the proper size of array and/or scores of current game.
    func initTotals(isResumingGame: Bool) {
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
//        print("init totals: \(totals)")
//        print("init finals: \(finalTotals)")
    }
    
    
//    func subscribe() {
//        $players
//            .sink { [weak self] players in
//                guard let self = self else { return }
//                for (i,player) in players.enumerated() {
//                    let total = Int(player.scores.map({ Int($0) ?? 0 }).reduce(0, +))
//                    let challenges = Int(player.challengeScores.map({ Int($0) ?? 0 }).reduce(0, +))
//                    self.totals[i] = total
//                    self.finalTotals[i] = total + challenges
////                    print("subscibed.totals: \(String(describing: self.totals))")
////                    print("subscibed.finals: \(String(describing: self.finalTotals))")
//                }
//            }
//            .store(in: &cancellables)
//    }
    
    
    func saveCurrentGame() {
        let savedGame = SavedGame(course: self.course, players: self.players)
        guard let data = try? JSONEncoder().encode(savedGame) else { return }
        self.savedGameData = data
    }
    
}

