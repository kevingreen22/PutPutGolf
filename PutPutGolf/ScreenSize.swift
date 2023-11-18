//
//  ScreenSize.swift
//  Created by Kevin Green on 11/11/23.
//

import SwiftUI

public extension View {
    
    /// Sets the screen size to a binding.
    func setScreenSize(_ screenSize: Binding<CGSize>) -> some View {
        self.modifier(ScreenSize(screenSize: screenSize))
    }
    
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}


struct ScreenSize: ViewModifier {
    @Binding var screenSize: CGSize
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader {
                    Color.clear.preference(key: SizePreferenceKey.self, value: $0.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) {
                screenSize = $0
            }
    }
}



