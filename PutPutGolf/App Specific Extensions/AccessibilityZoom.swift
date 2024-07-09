//
//  AccessibilityZoom.swift
//  PutPutGolf
//
//  Created by Kevin Green on 5/2/24.
//

import SwiftUI

struct AccessibilityZoom: ViewModifier {
    @Binding var zoom: Double
    
    func body(content: Content) -> some View {
        content
            .accessibilityZoomAction { action in
                if action.direction == .zoomIn {
                    zoom += 1
                } else {
                    zoom -= 1
                }
            }
    }
}
