//
//  TextFieldExtensions.swift
//  PutPutGolf
//
//  Created by Kevin Green on 12/30/23.
//

import SwiftUI

public extension View {
    
    /// Selects the text when this view is focused. An optional closure is available.
    func selectAllTextOnBeginEditing(_ action: (()->())? = nil) -> some View {
        modifier(SelectAllTextOnBeginEditingModifier(action: { action?() }))
    }
}

fileprivate struct SelectAllTextOnBeginEditingModifier: ViewModifier {
    var action: (()->())?
    
    public func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(
                for: UITextField.textDidBeginEditingNotification)) { output in
                    DispatchQueue.main.async {
                        UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
                        action?()
                    }
                }
        }
}
