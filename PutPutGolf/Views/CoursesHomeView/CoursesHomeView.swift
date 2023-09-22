//
//  MainView.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/18/23.
//

import SwiftUI

struct CoursesHomeView: View {
    @StateObject private var vm: CoursesHomeViewViewModel
    
    init(url: URL) {
        _vm = StateObject(wrappedValue: CoursesHomeViewViewModel(url: url))
    }
    
    var body: some View {
        List(vm.coursesData, rowContent: { course in
            Text("\(course.name)")
            Text("\(course.location)")
            Text("\(course.holes.count)")
            Text("\(course.challenges.count)")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesHomeView(url: URL(string: "")!)
    }
}
