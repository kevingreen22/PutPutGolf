//
//  PutPutGolfApp.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import SwiftUI

@main
struct PutPutGolfApp: App {
    var body: some Scene {
        WindowGroup {
            if let url = URL(string: "https://my.apiendpoint.courses") {
                CoursesHomeView(url: url)
            }
        }
    }
}
