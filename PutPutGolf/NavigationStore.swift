//
//  NavigationStore.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/30/23.
//

import SwiftUI

class NavigationStore: ObservableObject {
    @Published var path = NavigationPath()
    @Binding var bind: Bool
    
    init(bind: Binding<Bool>? = nil) {
        if bind != nil {
            _bind = bind!
        } else {
            _bind = .constant(false)
        }
    }
    
    /// Pushes/pulls a view on the navigation stack.
    /// - Parameter destination: The view destination to push/pull.
    func goto(_ destination: PutPutDestination) {
        switch destination {
        case .mapView: self.path = NavigationPath()
        case .playerSetup: self.path.append(1)
        case .scoreCard(players: let players): self.path.append(players)
        case .savedGame(let game): self.path.append(game)
        case .back(let k): self.path.removeLast(k)
        case .toggleBinding: self.bind.toggle()
        }
    }
    
    public enum PutPutDestination {
        case mapView
        case playerSetup
        case scoreCard(players: [Player])
        case savedGame(_ savedGame: SavedGame)
        case back(k: Int = 1)
        case toggleBinding
    }
    
    public struct DestinationID {
        static let mapView: Int = 0
        static let playerSetup: Int = 1
        static let scoreCard: Int = 2
        static let savedGame: Int = 3
        static let back: Int = 4
    }
    
}

