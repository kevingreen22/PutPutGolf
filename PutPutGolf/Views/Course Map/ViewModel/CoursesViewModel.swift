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
    var dataService: DataServiceProtocol
    var cancellables: Set<AnyCancellable> = []
    
    // All loaded courses
    @Published var coursesData: [Course] = []
    
    // Current coures on map
    @Published var selectedCourse: Course! { didSet { updateMapRegion(course: selectedCourse ?? Course()) } }
    
    // Current region on map
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
//    @Published var mapRegioniOS17: MapCameraPosition = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6)
    
    
//    @Published var rotation: CoursesMapInfo.RotationDegrees = .none
//    var players: [Player]?
//    @Published var title: String?

    // Show list of courses
    @Published var showCoursesList: Bool = false

    // Show course info sheet
    @Published var showCourseInfo: Bool = false

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        loadCourses()
        guard let firstCourse = coursesData.first else { return }
        selectedCourse = firstCourse
        updateMapRegion(course: firstCourse)
    }
    
    private func loadCourses() {
        dataService.getCourses()
            .sink { _ in
                // error or success
                
            } receiveValue: { [weak self] courses in
                guard let self = self else { return }
                self.coursesData = courses
            }
            .store(in: &cancellables)
    }
    
    func updateMapRegion(course: Course) {
        withAnimation(.easeInOut) {
//            mapRegion = MKCoordinateRegion(center: course.coordinates, span: mapSpan)
            mapRegion = MKCoordinateRegion(coordinates: coursesData.map({ $0.coordinates}))
        }
    }
    
//    func setSelectedCourse() {
//        $selectedCourse
//            .sink { [weak self] course in
//                guard let self = self else { return }
//                self.title = course?.name ?? nil
//            }
//            .store(in: &cancellables)
//    }

//    func setSelectedCourse() {
//        $rotation
//            .sink { [weak self] degree in
//                guard let self = self else { return }
//                switch degree {
//                case .left:
//                    let course = self.coursesData[0]
//                    self.selectedCourse = course
//                    self.title = course.name
//                    
//                case .leftMid:
//                    let course = self.coursesData[1]
//                    self.selectedCourse = course
//                    self.title = course.name
//                    
//                case .rightMid:
//                    let course = self.coursesData[2]
//                    self.selectedCourse = course
//                    self.title = course.name
//                    
//                case .right:
//                    let course = self.coursesData[3]
//                    self.selectedCourse = course
//                    self.title = course.name
//                    
//                case .none:
//                    self.selectedCourse = nil
//                    self.title = nil
//                }
//            }
//            .store(in: &cancellables)
//    }
    
    func toggleCoursesList() {
        withAnimation(.easeInOut) {
            showCoursesList.toggle()
        }
    }
    
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
    
    func getDirections() {
        if let selectedCourse = selectedCourse {
            let directionsURL = URL(string: "maps://?saddr=&daddr=\(selectedCourse.latitude),\(selectedCourse.longitude)")
            if let url = directionsURL, UIApplication.shared.canOpenURL(url) {
                print("\(type(of: self)).\(#function) - opening maps with directions: \(url)")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    
}




//extension MKCoordinateRegion {
//    static var myRegion: MKCoordinateRegion {
//        return MKCoordinateRegion(
//            center: CLLocationCoordinate2D(
//                latitude: 37.72,
//                longitude: -122.19
//            ),
//            span: MKCoordinateSpan(
//                latitudeDelta: 0.8,
//                longitudeDelta: 0.4)
//        )
//    }
//}
