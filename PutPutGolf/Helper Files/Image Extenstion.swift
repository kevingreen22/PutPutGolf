//
//  Image.swift
//
//  Created by Kevin Green on 10/19/23.
//

import SwiftUI

public extension Image {
    
    /// Initializes an new Image view with the UIImage passed or a system icon.
    /// - Parameters:
    ///   - uiimage: An optional UIImage object.
    ///   - systemName: The name of an SF symbol. Default if "person.fill":
    init(uiimage: UIImage?, systemName: String = "person.circle.fill") {
        if let uiimage = uiimage {
            self.init(uiImage: uiimage)
        } else {
            self.init(systemName: systemName)
        }
    }
    
}
