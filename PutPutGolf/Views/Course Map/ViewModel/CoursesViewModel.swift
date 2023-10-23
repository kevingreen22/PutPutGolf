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
    @AppStorage(AppStorageKeys.currentGame.rawValue) var currentGame: SavedGame?
    @AppStorage(AppStorageKeys.allSavedGames.rawValue) var allSavedGames: [SavedGame] = []
    
    // All loaded courses
    var coursesData: [Course] = []
    
    // Current coures on map
    @Published var selectedCourse: Course! {
        didSet {
            updateMapRegion(course: selectedCourse ?? Course())
        }
    }
    
    // Current region on map
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
//    @Published var mapRegioniOS17: MapCameraPosition = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6)
    
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
            mapRegion = MKCoordinateRegion(center: course.coordinates, span: mapSpan)
        }
    }
    
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

