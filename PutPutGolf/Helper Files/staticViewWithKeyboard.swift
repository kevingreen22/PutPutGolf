//
//  StaticViewWithKeyboard.swift
//  PutPutGolf
//
//  Created by Kevin Green on 11/24/23.
//

import SwiftUI

extension View {
    
    /// Prevents the view from moving upwards when the keyboard is shown.
    func staticViewWithKeyboard() -> some View {
        GeometryReader { _ in
            self
        }
        .ignoresSafeArea(.keyboard)
    }
    
}
