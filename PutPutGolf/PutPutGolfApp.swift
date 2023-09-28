//
//  PutPutGolfApp.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import SwiftUI

@main
struct PutPutGolfApp: App {
    @StateObject var coursesVM: CoursesViewModel
    
    init() {
        _coursesVM = StateObject(wrappedValue: CoursesViewModel(url: URL(string: "https://my.apiEndpoint.courses")))
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(coursesVM)
        }
    }
}
