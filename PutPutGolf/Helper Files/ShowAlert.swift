//
//  ShowAlert.swift
//  PutPutGolf
//
//  Created by Kevin Green on 4/18/24.
//

import SwiftUI

protocol AppAlert {
    var title: String { get }
    var message: String? { get }
    var buttons: AnyView { get }
}

extension View {
    
    func showAlert<T: AppAlert>(alert: Binding<T?>) -> some View {
        self
            .alert(alert.wrappedValue?.title ?? "Unknown", isPresented: Binding(value: alert)) {
                alert.wrappedValue?.buttons
            } message: {
                if let message = alert.wrappedValue?.message {
                    Text(message)
                }
            }
    }
    
}

extension Binding {
    init<T>(value: Binding<T?>) where Value == Bool {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}


