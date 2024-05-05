//
//  View Border.swift
//
//  Created by Kevin Green on 3/31/24.
//

import SwiftUI

/// Bordered View
extension View {
    
    /// Adds a shaped border to the view.
    public func addBorder<S: ShapeStyle>(_ content: S, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 0) -> some View {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: lineWidth))
    }
}
