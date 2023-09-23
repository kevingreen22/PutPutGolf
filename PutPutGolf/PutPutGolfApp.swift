//
//  PutPutGolfApp.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import SwiftUI

@main
struct PutPutGolfApp: App {
    let url = URL(string: "https://my.apiendpoint.courses")
    
    var body: some Scene {
        WindowGroup {
            CoursesHomeView(url: nil)
        }
    }
}
