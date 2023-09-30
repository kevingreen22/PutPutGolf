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
    @StateObject var navVM: NavigationViewModel = NavigationViewModel()
    
    init() {
        let url = URL(string: "https://my.apiEndpoint.courses")
        _coursesVM = StateObject(wrappedValue: CoursesViewModel(url: url))
    }
    
    var body: some Scene {
        WindowGroup {
            CoursesMapView()
                .environmentObject(coursesVM)
                .environmentObject(navVM)
        }
    }
}
