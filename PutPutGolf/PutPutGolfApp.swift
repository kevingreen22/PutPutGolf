//
//  PutPutGolfApp.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import SwiftUI

@main
struct PutPutGolfApp: App {
    @StateObject var navVM: NavigationStore = NavigationStore()
    var dataService: any DataServiceProtocol
    @State private var coursesData: [Course]?
    
    init() {
        print("\(type(of: self)).\(#function)-app.main")
        // PRODUCTION SERVICE
        let url = URL(string: "https://try3rg28fg.execute-api.us-west-1.amazonaws.com/live/courses")!
        dataService = ProductionDataService(url: url)
        
        // DEVELOPMENT MOCK SERVICE
//        dataService = MockDataService(mockData: MockData.instance)
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let coursesData = self.coursesData {
                    CoursesMap(coursesData: coursesData)
                        .environmentObject(navVM)
                } else {
                    LaunchScreenView()
                }
            }
            .task {
                await loadCourses() { courses in
                    self.coursesData = courses
                }
            }
        }
    }
    
    
    private func loadCourses(completion: @escaping ([Course]?)->()) async {
        dataService.fetchCourses { coursesData in
            guard let coursesData = coursesData else { return }
            print("\(type(of: self)).\(#function)-courses loaded")
            completion(coursesData)
        }
    }
}
