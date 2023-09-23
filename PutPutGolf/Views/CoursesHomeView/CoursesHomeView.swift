//
//  MainView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import SwiftUI

struct CoursesHomeView: View {
    @StateObject private var vm: CoursesHomeViewViewModel
    
    init(url: URL?) {
        _vm = StateObject(wrappedValue: CoursesHomeViewViewModel(url: url))
    }
    
    var body: some View {
        NavigationStack {
            List(vm.coursesData, rowContent: { course in
                NavigationLink(value: course) {
                    CourseListCell(course: course)
                }
            })
            
            .navigationTitle("Putter's Country Clubs")
            .navigationDestination(for: Course.self) { course in
                CourseInfoView(course: course)
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static let url = URL(string: "")
    
    static var previews: some View {
        CoursesHomeView(url: url)
    }
}


