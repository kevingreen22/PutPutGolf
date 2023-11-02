//
//  ScoreCardViewModel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/21/23.
//

import SwiftUI
import Combine

@MainActor class ScoreCardViewModel: ObservableObject {
    typealias Totals = Int
    typealias FinalTotals = Int
    var course: Course
    @Published var players: [Player]
    @Published var totals: [Totals] = []
    @Published var finalTotals: [FinalTotals] = []
    var cancellables: Set<AnyCancellable> = []
    @AppStorage(AppStorageKeys.savedGames.description) var savedGames: [SavedGame] = []
    var isGameCompleted: Bool = false

    
    init(course: Course, players: [Player], isResumingGame: Bool = false) {
        print("\(type(of: self)).\(#function)")
        self.course = course
        self.players = players
        initTotals(isResumingGame: isResumingGame)
        subscribeForGameIsFinished()
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
    
    
    /// Checks if the game is completed and sets the isGameCompleted variable.
    /// This is specifically used for saving the game, as there are two keys of app storage for games.
    fileprivate func subscribeForGameIsFinished() {
        $players
            .sink { [weak self] values in
                for player in values {
                    guard player.scores.allSatisfy({ $0 != "" }) else { return }
                    guard player.challengeScores.allSatisfy({ $0 != "" }) else { return }
                    self?.isGameCompleted = true
                }
            }
            .store(in: &cancellables)
    }
    
    
    /// Saves the current game to AppStorage.
    func saveCurrentGame() {
        let game = SavedGame(course: self.course, players: self.players, isCompleted: isGameCompleted)
        self.savedGames.append(game)
    }
    
}

