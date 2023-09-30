//
//  ScoreCardViewModel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/21/23.
//

import SwiftUI
import Combine

class ScoreCardViewModel: ObservableObject {
    @Published var score: String = ""
    @Published var players: [Player] = MockData.instance.players
    var cancellables: Set<AnyCancellable> = []
    
    
    
    
    
    func updateScore(player: Player, hole: Hole) {
        
    }
    
    
}

