//
//  SetupPlayerViewModel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/29/23.
//

import SwiftUI
import Combine

class SetupPlayerViewModel: ObservableObject {
    @Published var playerName: String = ""
    var playerCount: String = "One"
    @FocusState var focusedTextField
    
    var playersNames: [String] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        focusedTextField = true
        setupPlayerNameSubscriber()
    }
    
    func setupPlayerNameSubscriber() {
        $playerName
            .sink { [weak self] playerName in
                guard let self = self else { return }
                
//                switch self.playerCount {
//                case "One": playerCount = "Two"
//                case "Two": playerCount = "Three"
//                case "Three": playerCount = "Four"
//                default: break
//                }
                
            }
            .store(in: &cancellables)
    }
    
}
