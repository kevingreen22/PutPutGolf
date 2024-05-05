//
//  SettingsButton.swift
//  PutPutGolf
//
//  Created by Kevin Green on 4/27/24.
//

import SwiftUI


extension View {
    func settingsButton(alignment: Alignment = .center, systemName: String = "gearshape.circle.fill", action: @escaping ()->Void) -> some View {
        self.overlay(alignment: alignment) {
            SettingsButton {
                action()
            }
        }
    }
}

struct SettingsButton: View {
    var action: ()->Void
    var systemName: String = "gearshape.circle.fill"
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .resizable()
        }
    }
}

#Preview {
    SettingsButton() {
        // do something here
    }
}
