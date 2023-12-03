//
//  ErrorAlerts.swift
//  PutPutGolf
//
//  Created by Kevin Green on 12/2/23.
//

import SwiftUI

protocol AppAlert {
    var title: String { get }
    var message: String? { get }
    var buttons: AnyView { get }
}

extension View {
    
    func showErrorAlert<T: AppAlert>(alert: Binding<T?>) -> some View {
        self
            .alert(alert.wrappedValue?.title ?? "Error", isPresented: Binding(value: alert)) {
                alert.wrappedValue?.buttons
            } message: {
                if let message = alert.wrappedValue?.message {
                    Text(message)
                }
            }

    }
}

enum ErrorAlerts: Error, LocalizedError, AppAlert  {
    case basic(String)
    case advanced(action: ()->Void)
    case decodeFailure
    case fetchFailed
    case postFailed
    
    
    var errorDescription: String? {
        switch self {
        case .basic(error: let error): "There was and error: \(error.description)"
        case .advanced: "Opps, something went really wrong."
        case .decodeFailure: "Error decoding JSON."
        case .fetchFailed: "Error fetching data."
        case .postFailed: "Error posting data."
        }
    }
    
    var title: String {
        switch self {
        case .basic: "Error"
        case .advanced: "Major Error"
        case .decodeFailure: "Decode Error"
        case .fetchFailed: "Fetching Failed"
        case .postFailed: "Posting Failed"
        }
    }
    
    var message: String? {
        switch self {
        case .basic: "Someting went wrong, please try again."
        case .advanced: "Something went horibly wrong."
        case .decodeFailure: "There was an error decoding JSON object."
        case .fetchFailed, .postFailed: nil
        }
    }
    
    var buttons: AnyView {
        AnyView(getButtons)
    }
    
    @ViewBuilder var getButtons: some View {
        switch self {
        case .basic, .decodeFailure, .fetchFailed, .postFailed:
            Button("Ok") { }
        case .advanced(action: let action):
            Button("Ok") { action() }
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
