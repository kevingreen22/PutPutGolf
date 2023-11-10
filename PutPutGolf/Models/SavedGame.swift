//
//  SavedGame.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/28/23.
//

import Foundation

enum AppStorageKeys: CustomStringConvertible {
    case savedGames
    
    var description: String {
        switch self {
        case .savedGames: return "savedGames"
        }
    }
}


struct SavedGame: Codable, Equatable, Hashable, Identifiable {
    var id: String
    var course: Course
    var players: [Player]
    var isCompleted: Bool
    var date: Date
    var dateString: String {
        self.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    init(id: String, course: Course, players: [Player], isCompleted: Bool, date: Date = Date()) {
        self.id = id
        self.course = course
        self.players = players
        self.isCompleted = isCompleted
        self.date = date
    }
}


/// Allows SavedGame struct to be saved in AppStorage/SceneStorage
extension SavedGame: RawRepresentable {
    
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8), 
                let result = try? JSONDecoder().decode(SavedGame.self, from: data)
        else { return nil }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self), 
                let result = String(data: data, encoding: .utf8) 
        else { return "" }
        return result
    }
    
    
    
    
    /// https://stackoverflow.com/questions/74190477/app-crashes-when-setting-custom-struct-value-in-appstorage
    
    /// Implementing this solves the infinite recursion issue when types that conforms to both Encodable and RawRepresentable automatically get this encode(to:) implementation(sourceA), which encodes the raw value. This means that when you call JSONEncoder().encode, it would try to call the getter of rawValue, which calls JSONEncoder().encode, forming the infinite recursion.
    ///
    /// To solve this, you can implement encode(to:) explicitly.
    /// Note that you should also implement init(from:) explicitly. (see below)
    ///
    /// ```
    /// func encode(to encoder: Encoder) throws {
    ///     var container = encoder.unkeyedContainer()
    ///     try container.encode(id) <-- where "id" is one of the struct's properties.
    /// }
    /// ```
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(id)
        try container.encode(course)
        try container.encode(players)
        try container.encode(isCompleted)
        try container.encode(date)
    }
    
    /// https://stackoverflow.com/questions/74190477/app-crashes-when-setting-custom-struct-value-in-appstorage
    
    /// Implementing this solves the infinite recursion issue when types that conforms to both Encodable and RawRepresentable automatically get this encode(to:) implementation(sourceA), which encodes the raw value. This means that when you call JSONEncoder().encode, it would try to call the getter of rawValue, which calls JSONEncoder().encode, forming the infinite recursion.
    ///
    ///
    /// To solve this, you can implement init(from:) explicitly, because you also get a init(from:) implementation that tries to decode your JSON as a single JSON string, which you certainly do not want.
    /// Note that you should also implement encode(to:) explicitly. (see above)
    ///
    /// ```
    /// init(from decoder: Decoder) throws {
    ///     var container = try decoder.unkeyedContainer()
    ///     id = try container.decode(UUID.self) <-- **Adding all properies types.** Including all duplicates.
    /// }
    /// ```
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        id = try container.decode(String.self)
        course = try container.decode(Course.self)
        players = try container.decode([Player].self)
        isCompleted = try container.decode(Bool.self)
        date = try container.decode(Date.self)
    }
    
}
