//
//  Courses.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import Foundation
import MapKit
import SwiftUI

struct Course: Codable, Hashable, Equatable, Identifiable {
    var id = UUID()
    var name: String
    var address: String
    var location: [Float]
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



