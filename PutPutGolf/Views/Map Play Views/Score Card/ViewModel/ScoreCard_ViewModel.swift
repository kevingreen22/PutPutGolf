//
//  ScoreCard_ViewModel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/21/23.
//

import SwiftUI
import Combine

// MARK: ScoreCardView View Model
extension ScoreCardView {
    
    @MainActor final class ViewModel: ObservableObject {
        var course: Course
        
        typealias Totals = String
        typealias FinalTotals = String
        
//        @AppStorage(AppStorageKeys.savedGames.description) var savedGames: [SavedGame]?
        
        @Published var players: [Player]
        @Published var totals: [Totals] = []
        @Published var finalTotals: [FinalTotals] = []
        @Published var isGameCompleted: Bool = false
        @Published var showWinnerView: Bool = false
        @Published var showBracketView: Bool = false
        @Published var challenge: Challenge? = nil
        @Published var showExitAlert: Bool = false
        @Published var isQuickPlayGame: Bool = false
        
        var cancellables: Set<AnyCancellable> = []
        var winnerBracket: [Player] = []
        
        init(course: Course, players: [Player], isResumingGame: Bool = false, isQuickPlayGame: Bool = false) {
            print("\(type(of: self)).\(#function)")
            self.course = course
            self.players = players
            self.isQuickPlayGame = isQuickPlayGame
            initTotals(isResumingGame: isResumingGame)
            subToPlayers()
        }
        
        /// Inits scores with the proper size of array and/or scores of current game.
        func initTotals(isResumingGame: Bool) {
            if isResumingGame {
                for player in players {
                    let total = Int(player.scores.map({ Int($0) ?? 0 }).reduce(0, +))
                    let challenges = Int(player.challengeScores.map({ Int($0) ?? 0 }).reduce(0, +))
                    totals.append(String(total))
                    let finalTotalStr = String(total + challenges)
                    finalTotals.append(finalTotalStr)
                }
            } else {
                for player in players {
                    player.scores = Array(repeating: "0", count: course.holes.count)
                    if let challenges = course.challenges {
                        player.challengeScores = Array(repeating: "0", count: challenges.count)
                    }
                    
                    let total = Int(player.scores.map({ Int($0) ?? 0 }).reduce(0, +))
                    let challenges = Int(player.challengeScores.map({ Int($0) ?? 0 }).reduce(0, +))
                    
                    totals.append(String(total))
                    let finalTotalStr = String(total + challenges)
                    finalTotals.append(finalTotalStr)
                }
            }
        }
        
        /// Subscribes to Players publisher.
        fileprivate func subToPlayers() {
            $players
                .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
                .sink { [weak self] players in
                    for (index,player) in players.enumerated() {
                        self?.updateTotals(for: player, at: index)
                        self?.checkIfGameIsFinished(for: player, at: index)
                    }
                }
                .store(in: &cancellables)
        }
        
        /// Updates the total fields in the scorecard.
        fileprivate func updateTotals(for player: Player, at index: Int) {
            print("\(type(of: self)).\(#function)")
            var total = 0
            for score in player.scores {
                guard let score = Int(score) else { return }
                total += score
            }
            self.totals[index] = String(total)
            
            var finalTotal = 0
            for score in player.challengeScores {
                guard let score = Int(score) else { return }
                finalTotal += score
            }
            //        print("total: \(total)")
            //        print("finalTotal: \(finalTotal)")
            let finalTotalStr = String(total + finalTotal)
            self.finalTotals[index] = finalTotalStr
        }
        
        /// Checks if the game is completed and sets the isGameCompleted variable.
        fileprivate func checkIfGameIsFinished(for player: Player, at index: Int) {
            print("\(type(of: self)).\(#function)")
            if !isQuickPlayGame {
                for player in self.players {
                    guard player.scores.allSatisfy({ $0 != "" && Character($0).isNumber && $0 != "0" }), player.challengeScores.allSatisfy({ $0 != "" && $0 != " " && $0 != "0" }) else {
                        self.isGameCompleted = false
                        self.showWinnerView = false
                        return
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.isGameCompleted = true
                        self.setWinnerBracket()
                        self.showWinnerView = true
                    }
                }
            }
        }
        
        /// Creates an array of tuples containing the player and their final score. Sorted lowest to highest.
        fileprivate func setWinnerBracket() {
            self.winnerBracket = players.sorted { $0.totalScore() < $1.totalScore() }
        }
        
        var getWinner: Player? {
            guard let winner = winnerBracket.first else { return nil }
            return winner
        }
        
        /// Saves the current game to AppStorage.
        //    func saveCurrentGame() {
        //        let game = SavedGame(id: UUID().uuidString, course: self.course, players: self.players, isCompleted: isGameCompleted)
        //        if savedGames != nil {
        //            self.savedGames!.append(game)
        //        } else {
        //            self.savedGames = [game]
        //        }
        //    }
        
    }
    
}

