//
//  CoursesMap_ViewModel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/22/23.
//

import SwiftUI
import Combine
import MapKit

extension CoursesMap {
    
    // MARK: CoursesMap View Model
    @MainActor final class ViewModel: ObservableObject {
        var cancellables: Set<AnyCancellable> = []
        
        // All loaded courses
        @Published var coursesData: [Course] = []
        
        // Current coures on map
        @Published var selectedCourse: Course = Course()
        
        // Current region on map
        @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6)
        
        @Published var errorAlert: AlertType?
        @Published var showCoursesList: Bool = false
        @Published var showCourseInfo: Bool = false
        
        init() {
            print("\(type(of: self)).\(#function)")
            subToSelectedCourse()
        }
        
        private func subToSelectedCourse() {
            $selectedCourse
                .sink { [weak self] course in
                    guard let self = self else { return }
                    self.updateMapRegion(course: course)
                }
                .store(in: &cancellables)
        }
        
        /// Updates the maps visible region.
        func updateMapRegion(course: Course) {
            withAnimation(.easeInOut) {
                mapRegion = MKCoordinateRegion(center: course.coordinates, span: mapSpan)
            }
        }
        
        /// Shows the Course list.
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
            let directionsURL = URL(string: "maps://?saddr=&daddr=\(selectedCourse.latitude),\(selectedCourse.longitude)")
            if let url = directionsURL, UIApplication.shared.canOpenURL(url) {
                print("\(type(of: self)).\(#function) - opening maps with directions: \(url)")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
    }
}
