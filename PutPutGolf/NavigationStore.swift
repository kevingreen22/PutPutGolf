//
//  NavigationStore.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/30/23.
//

import SwiftUI

class NavigationStore: ObservableObject {
    @Published var path = NavigationPath()
    
    func goto(_ destination: Destination) {
        switch destination {
        case .mapView: self.path = NavigationPath()
        case .playerSetup: self.path.append(1)
        case .scoreCard(players: let players): self.path.append(players)
        case .savedGame(let game): self.path.append(game)
        case .back(let k): self.path.removeLast(k != nil ? k! : 1)
        }
    }
    
    public enum Destination {
        case mapView
        case playerSetup
        case scoreCard(players: [Player])
        case savedGame(_ savedGame: SavedGame)
        case back(k: Int?)
    }
    
    public struct DestinationID {
        static let mapView: Int = 0
        static let playerSetup: Int = 1
    }
    
}
