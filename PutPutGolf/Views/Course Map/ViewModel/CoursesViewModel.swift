//
//  CoursesViewModel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/22/23.
//

import SwiftUI
import Combine
import MapKit

class CoursesViewModel: ObservableObject {
//    var dataService: any DataServiceProtocol
    var cancellables: Set<AnyCancellable> = []
    
    // All loaded courses
    @Published var coursesData: [Course] = []
    
    // Current coures on map
    @Published var selectedCourse: Course = Course()
    
    // Current region on map
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6)
    
    @Published var showCoursesList: Bool = false
    @Published var showCourseInfo: Bool = false

    
    init(coursesData: [Course]) {
        print("\(type(of: self)).\(#function)")
        self.coursesData = coursesData
        if let first = coursesData.first {
            self.selectedCourse = first
        }
//        loadCourses()
        subToSelectedCourse()
    }
    
    
//    private func loadCourses() {
////        dataService.gettCourses { courses in
////            guard let courses = courses, let firstCourse = courses.first else { return }
////            self.coursesData = courses
////            self.selectedCourse = firstCourse
////        }
//        
//        dataService.getCourses()
//            .retry(3) // good for retrying api calls that error out.
////            .timeout(10, scheduler: DispatchQueue.global()) // terminates publishing after amount of time.
//            .sink { error in
//                switch error {
//                case .finished: print("Courses Loaded")
//                case .failure(let error):  print("load Courses error: \(error)")
//                }
//            } receiveValue: { [weak self] courses in
//                guard let self = self, let firstCourse = courses.first else { return }
//                self.coursesData = courses
//                self.selectedCourse = firstCourse
//            }
//            .store(in: &cancellables)
//    }
    
    
    private func subToSelectedCourse() {
        $selectedCourse
            .sink { [weak self] course in
                guard let self = self else { return }
                self.updateMapRegion(course: course)
            }
            .store(in: &cancellables)
    }
    
    
    func updateMapRegion(course: Course) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(center: course.coordinates, span: mapSpan)
        }
    }
    
    
    func toggleCoursesList() {
        withAnimation(.easeInOut) {
            showCoursesList.toggle()
        }
    }
    
    
    /// Shows the next course info panel on the map.
    /// - Parameter course: The Course to show.
    func showNextCourse(course: Course?) {
        withAnimation(.easeInOut) {
            if let course = course {
                selectedCourse = course
                showCoursesList = false
            } else {
                // Get current index
                guard let currentIndex = coursesData.firstIndex(where: { $0 == selectedCourse }) else { return }
                
                // Check if currentIndex is valid
                let nextIndex = currentIndex + 1
                guard coursesData.indices.contains(nextIndex) else {
                    // nextIndex is NOT valid
                    // Restart from 0
                    guard let firstCourse = coursesData.first else { return }
                    showNextCourse(course: firstCourse)
                    return
                }
                
                // nextIndex IS valid
                let nextCourse = coursesData[nextIndex]
                showNextCourse(course: nextCourse)
            }
        }
    }
    
    
    /// Opens the Maps.app with directions to the selected course.
    func getDirections() {
//        if let selectedCourse = selectedCourse {
            let directionsURL = URL(string: "maps://?saddr=&daddr=\(selectedCourse.latitude),\(selectedCourse.longitude)")
            if let url = directionsURL, UIApplication.shared.canOpenURL(url) {
                print("\(type(of: self)).\(#function) - opening maps with directions: \(url)")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
//        }
    }
    
}

