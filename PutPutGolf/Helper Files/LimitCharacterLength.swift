//
//  LimitCharacterLength.swift
//  PutPutGolf
//
//  Created by Kevin Green on 12/2/23.
//

import SwiftUI
import Combine

extension View {
    
    /// Keeps text length to a limited number of characters.
    func limitCharacterLength(limit: Int, text: Binding<String>) -> some View {
        self
            .onReceive(Just(text), perform: { _ in
                if text.wrappedValue.count > limit {
                    text.wrappedValue = String(text.wrappedValue.prefix(limit))
                }
            })
    }
    
    /// Keeps text length to a limited number of characters.
    func limitIntLength(limit: Int, value: Binding<Int>) -> some View {
        self
            .onReceive(Just(value), perform: { _ in
                let count = String(value.wrappedValue).count
                if count > limit {
                    let limitedStr = String(value.wrappedValue).prefix(limit)
                    guard let limitedInt = Int(limitedStr) else { return }
                    value.wrappedValue = limitedInt
                }
            })
    }
    
    
}
