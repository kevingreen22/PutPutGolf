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
    @Published var coursesData: [Course] = []
    @Published var selectedCourse: Course? 
    
    init(url: URL?) {
        if let url = url {
            self.dataService = ProductionDataService(url: url)
        } else {
            self.dataService = MockDataService(mockData: MockData.instance)
        }
        
        loadCourses()
    }
    
    func loadCourses() {
        dataService.getCourses()
            .sink { _ in
                
            } receiveValue: { [weak self] courses in
                guard let self = self else { return }
                self.coursesData = courses
                self.selectedCourse = courses.first!
            }
            .store(in: &cancellables)
    }
    
    func setSelectedCourse() {
        selectedCourse
            .publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newValue in
                guard let self = self else { return }
                self.selectedCourse = newValue
            })
            .store(in: &cancellables)
    }
    
}
