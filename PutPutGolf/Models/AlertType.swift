//
//  AlertType.swift
//  PutPutGolf
//
//  Created by Kevin Green on 12/2/23.
//

import SwiftUI

class AlertContext: ObservableObject {
    @Published var alert: AlertType? = nil
    
    func ofType(_ type: AlertType) {
        self.alert = type
    }

}


enum AlertType: Error, LocalizedError, AppAlert  {
    case error(error: String)
    case decodeFailure
    case fetchFailed
    case postFailed
    case loginFailed
    case uploadCourseFailed
    case validationFailed
    
    case basic(title: String, message: String? = nil)
    case custom(title: String, message: String, buttons: [Button<AnyView>])
    case wrongPlayerAmount
    case finishAndShowWinner(action1: ()->Void, action2: (Bool)->Void)
    
        
    var title: String {
        switch self {
        case .error: "Error"
        case .decodeFailure: "Decode Error"
        case .fetchFailed: "Fetching Failed"
        case .postFailed: "Posting Failed"
        case .loginFailed: "Login Failed"
        case .uploadCourseFailed: "Upload Failed"
        case .validationFailed: "Validation Failed"
            
        case .basic(let title, _): title
        case .custom(title: let title, message: _, _): title
        case .wrongPlayerAmount: "Invalid number of Players"
        case .finishAndShowWinner: "End Game?"
        }
    }
    
    var message: String? {
        switch self {
        case .error(error: let error): error.description
        case .decodeFailure: "There was an error decoding JSON object."
        case .fetchFailed, .postFailed: nil
        case .loginFailed: "Username and/or password incorrect. Try again."
        case .uploadCourseFailed: "There was an error uploading new Course. Please try again."
        case .validationFailed: "Failed to validate info. Please try again."
            
        case .basic(title: _, message: let message): message
        case .custom(title: _, message: let message, _): message
        case .wrongPlayerAmount: "Please choose between 1 and 10 players."
        case .finishAndShowWinner: "Are you sure your finished playing all holes?"
        }
    }
    
    var buttons: AnyView {
        AnyView(getButtons)
    }
    
    @ViewBuilder var getButtons: some View {
        switch self {
        case .basic, .error, .decodeFailure, .fetchFailed, .postFailed, .loginFailed, .uploadCourseFailed, .validationFailed, .wrongPlayerAmount:
            Button("Ok") { }
            
        case .custom(_, _, let buttons):
            ForEach(Array(buttons.enumerated()), id: \.offset) { (idx, button) in
                button
            }
            
        case .finishAndShowWinner(let action1, let action2):
            Button("Finished", role: .destructive) { action1() }
            Button("Keep Playing") { action2(false) }
        }
    }
    
    var description: String? {
        switch self {
        case .error(error: let error): error.description
        case .decodeFailure: "Error decoding JSON."
        case .fetchFailed: "Error fetching data."
        case .postFailed: "Error posting data."
        case .loginFailed: "Error logging in with credentials."
        case .uploadCourseFailed: "Error uploading new course."
        case .validationFailed: "Failed to validate info. Some/all fields are not filled."
                        
        default: ""
        }
    }

    
}







