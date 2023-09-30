//
//  CoursesMapInfo.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/28/23.
//

import SwiftUI

public struct CoursesMapInfo {
    static var iconPlacement: [(RotationDegrees, CGPoint)] = [
        (.left,iconPositions[0]),
        (.leftMid,iconPositions[1]),
        (.rightMid,iconPositions[2]),
        (.right,iconPositions[3])
    ]
    
    static private var iconPositions: [CGPoint] = [
        CGPoint(x: 70, y: 500),
        CGPoint(x: 120, y: 700),
        CGPoint(x: 300, y: 700),
        CGPoint(x: 365, y: 500)
    ]
    
    static private var degrees: [RotationDegrees] = [.none,.left,.leftMid,.rightMid,.right]
    
    public enum RotationDegrees: Double {
        case none = 0
        case left = 27
        case leftMid = 10.0
        case rightMid = -10.0
        case right = -27
    }
}

