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
    @StateObject var navVM: NavigationStore = NavigationStore()
    
    init() {
//        guard let url = URL(string: "https://my.apiEndpoint.courses") else { return }
//        let dataService = ProductionDataService(url: url)
//        _coursesVM = StateObject(wrappedValue: CoursesViewModel(dataService: dataService) )
        
        let dataService = MockDataService(mockData: MockData.instance)
        _coursesVM = StateObject(wrappedValue: CoursesViewModel(dataService: dataService))
    }
    
    var body: some Scene {
        WindowGroup {
            CoursesMap()
                .environmentObject(coursesVM)
                .environmentObject(navVM)
        }
    }
}
