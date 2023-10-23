//
//  SavedGame.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/28/23.
//

import Foundation

struct SavedGame: Codable, Equatable, Hashable, Identifiable {
    var id = UUID()
    var course: Course
    var players: [Player]
    var date: Date = Date()
    var dateString: String {
        self.date.formatted(date: .abbreviated, time: .omitted)
    }
}

enum AppStorageKeys: String, CustomStringConvertible {
    case currentGame
    case allSavedGames
    
    var description: String {
        switch self {
        case .currentGame: return "currentGame"
        case .allSavedGames: return "allSavedGames"
        }
    }
}


/// Allows SavedGame struct to be saved in AppStorage/SceneStorage
extension SavedGame: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(SavedGame.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
