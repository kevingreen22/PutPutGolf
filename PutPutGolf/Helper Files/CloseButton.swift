//
//  CloseButton.swift
//  PutPutGolf
//
//  Created by Kevin Green on 1/1/24.
//

import SwiftUI

public extension View {
    /// Easy close button overlay, with an optional closure action.
    func closeButton(
        alignment: Alignment = .topTrailing,
        iconName: String = "xmark",
        fontSize: Font? = .title,
        action: (()->())? = nil
    ) -> some View {
        self.overlay(alignment: alignment) {
            CloseButton(iconName: iconName, fontSize: fontSize, action: action)
            }
    }
}

public struct CloseButton: View {
    @Environment(\.dismiss) var dismiss
    var iconName: String = "xmark"
    var fontSize: Font? = .title
    var action: (()->())? = nil
    
    public var body: some View {
        Button {
            if let action = action { action() }
            dismiss()
        } label: {
            Image(systemName: iconName)
                .font(fontSize ?? Font.title)
                .foregroundStyle(Color.white)
                .padding(8)
                .background(Color.gray.opacity(0.7).blur(radius: 3.0))
                .shadow(radius: 10)
                .clipShape(Circle())
        }
        .ignoresSafeArea()
    }
}

#Preview {
    return VStack {
        Text("Close button")
    }
    .frame(width: 300, height: 300)
    .background { Color.red }
    .closeButton()
}

