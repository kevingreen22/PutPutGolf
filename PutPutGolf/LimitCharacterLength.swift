//
//  LimitCharacterLength.swift
//  PutPutGolf
//
//  Created by Kevin Green on 12/2/23.
//

import SwiftUI
import Combine

extension TextField {
    
    /// Keeps text length to a limited number of characters.
    func limitCharacterLength(limit: Int, text: Binding<String>) -> some View {
        self
            .onReceive(Just(text), perform: { _ in
                if text.wrappedValue.count > limit {
                    text.wrappedValue = String(text.wrappedValue.prefix(limit))
                }
            })
    }
    
}

