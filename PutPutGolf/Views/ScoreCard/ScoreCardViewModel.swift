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
    var cancellables: Set<AnyCancellable> = []
    
    func updateScore(player: Player, hole: Hole) {
        
    }
    
    
}

