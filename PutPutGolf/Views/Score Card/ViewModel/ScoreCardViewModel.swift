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
    @AppStorage(AppStorageKeys.savedGames.description) var savedGames: [SavedGame]?
    
    @Published var players: [Player]
    @Published var totals: [Totals] = []
    @Published var finalTotals: [FinalTotals] = []
    
    var course: Course
    var cancellables: Set<AnyCancellable> = []
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
    fileprivate func subscribeForGameIsFinished() {
        $players
            .sink { [weak self] values in
                for player in values {
                    guard player.scores.allSatisfy({ $0 != "" }) else {
                        self?.isGameCompleted = false
                        return
                    }
                    guard player.challengeScores.allSatisfy({ $0 != "" }) else {
                        self?.isGameCompleted = false
                        return
                    }
                    self?.isGameCompleted = true
                }
            }
            .store(in: &cancellables)
    }
    
    
    /// Saves the current game to AppStorage.
    func saveCurrentGame() {
        let game = SavedGame(id: UUID().uuidString, course: self.course, players: self.players, isCompleted: isGameCompleted)
        if savedGames != nil {
            self.savedGames!.append(game)
        } else {
            self.savedGames = [game]
        }
    }
    
}

