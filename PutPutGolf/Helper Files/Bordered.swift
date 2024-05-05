//
//  Bordered.swift
//
//  Created by Kevin Green on 12/5/23.
//

import SwiftUI

public extension View {
    
    /// A quicker easier way to border a view via a shape overlay.
    func bordered<S:Shape>(shape: S, color: Color, lineWidth: CGFloat = 1) -> some View {
        self.overlay {
                shape.stroke(color, lineWidth: lineWidth)
            }
    }
    
}
