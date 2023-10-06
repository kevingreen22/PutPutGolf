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
    var id = UUID()
    var name: String
    var address: String
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
//    var location: [Float]
//    var location: CLLocationCoordinate2D
    var imageData: Data?
    var difficulty: Difficulty
    var holes: [Hole]
    var challenges: [Challenge]
    var rules: [String]
    var hours: [String]
    
    func totalPar() -> Int {
        var totalPar = 0
        for hole in holes {
            totalPar += hole.par
        }
        return totalPar
    }
    
    
    func getImage() -> Image {
        guard let data = self.imageData, let img = UIImage(data: data) else { return Image(systemName: "photo.fill") }
            return Image(uiImage: img)
    }
    
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.difficulty == rhs.difficulty &&
        lhs.holes == rhs.holes &&
        lhs.challenges == rhs.challenges
    }
}



//extension CLLocationCoordinate2D: Codable {
//    public enum CodingKeys: String, CodingKey {
//        case latitude
//        case longitude
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(latitude, forKey: .latitude)
//        try container.encode(longitude, forKey: .longitude)
//        }
//
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        latitude = try values.decode(Double.self, forKey: .latitude)
//        longitude = try values.decode(Double.self, forKey: .longitude)
//    }
//}
