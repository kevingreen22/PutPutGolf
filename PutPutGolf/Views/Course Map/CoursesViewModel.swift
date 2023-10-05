//
//  CoursesViewModel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/22/23.
//

import SwiftUI
import Combine

class CoursesViewModel: ObservableObject {
    var dataService: DataServiceProtocol
    var cancellables: Set<AnyCancellable> = []
    var coursesData: [Course] = []
    
    @Published var selectedCourse: Course?
    var players: [Player]?
    @Published var rotation: CoursesMapInfo.RotationDegrees = .none
    @Published var title: String?
    @Published var showCourseInfo: Bool = false
    
    init(url: URL?) {
        if let url = url {
            self.dataService = ProductionDataService(url: url)
        } else {
            self.dataService = MockDataService(mockData: MockData.instance)
        }
        
        loadCourses()
        setSelectedCourse()
    }
    
    func loadCourses() {
        dataService.getCourses()
            .sink { _ in
                // error or success
                
            } receiveValue: { [weak self] courses in
                guard let self = self else { return }
                self.coursesData = courses
            }
            .store(in: &cancellables)
    }
    
    
    func setSelectedCourse() {
        $rotation
            .sink { [weak self] degree in
                guard let self = self else { return }
                switch degree {
                case .left:
                    let course = self.coursesData[0]
                    self.selectedCourse = course
                    self.title = course.name
                    
                case .leftMid:
                    let course = self.coursesData[1]
                    self.selectedCourse = course
                    self.title = course.name
                    
                case .rightMid:
                    let course = self.coursesData[2]
                    self.selectedCourse = course
                    self.title = course.name
                    
                case .right:
                    let course = self.coursesData[3]
                    self.selectedCourse = course
                    self.title = course.name
                    
                case .none:
                    self.selectedCourse = nil
                    self.title = nil
                }
            }
            .store(in: &cancellables)
    }
    
    
    
    func getDirections() {
        if let course = selectedCourse {
            let longitude = course.location[1]
            let latitude = course.location[0]
            let directionsURL = URL(string: "maps://?saddr=&daddr=\(longitude),\(latitude)")
            if let url = directionsURL, UIApplication.shared.canOpenURL(url) {
                print("\(type(of: self)).\(#function) - opening maps with directions: \(url)")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}

