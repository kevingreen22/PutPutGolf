//
//  CoursesHomeViewViewModel.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/22/23.
//

import SwiftUI
import Combine

class CoursesHomeViewViewModel: ObservableObject {
    var dataService: DataServiceProtocol
    var cancellables: Set<AnyCancellable> = []
    @Published var coursesData: [Course] = []
    
    init(url: URL) {
        self.dataService = ProductionDataService(url: url)
        loadCourses()
    }
    
    func loadCourses() {
        dataService.getCourses()
            .sink { _ in
                
            } receiveValue: { [weak self] courses in
                guard let self = self else { return }
                self.coursesData = courses
            }
            .store(in: &cancellables)
    }
    
}
