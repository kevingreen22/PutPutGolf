//
//  Courses.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import Foundation
import MapKit
import SwiftUI
import MapKit

struct Course: Codable, Hashable, Equatable, Identifiable {
    var id: String
    var name: String
    var address: String
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var imageData: Data?
    var difficulty: Difficulty
    var holes: [Hole]
    var challenges: [Challenge]
    var rules: [String]
    var hours: [String]
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    init(id: String, name: String, address: String, latitude: Double, longitude: Double, imageData: Data? = nil, difficulty: Difficulty, holes: [Hole], challenges: [Challenge], rules: [String], hours: [String]) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.imageData = imageData
        self.difficulty = difficulty
        self.holes = holes
        self.challenges = challenges
        self.rules = rules
        self.hours = hours
    }
    
    
    /// Initialzes a blank Course.
    init() {
        self.id = UUID().uuidString
        self.name = "Unknown"
        self.address = "Unknown"
        self.latitude = 0
        self.longitude = 0
        self.imageData = nil
        self.difficulty = .easy
        self.holes = []
        self.challenges = []
        self.rules = []
        self.hours = []
    }
    
    
    
    func totalPar() -> Int {
        var totalPar = 0
        for hole in holes {
            totalPar += hole.par
        }
        return totalPar
    }
    
    
    func getImage() -> Image {
        guard let data = self.imageData,
                let img = UIImage(data: data) else {
            return Image("plain_ball")
        }
        return Image(uiImage: img)
    }
    
    // Equatable
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.difficulty == rhs.difficulty &&
        lhs.holes == rhs.holes &&
        lhs.challenges == rhs.challenges
    }
}
