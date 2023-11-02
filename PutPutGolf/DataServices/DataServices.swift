//
//  DataServices.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/22/23.
//

import SwiftUI
import Combine

protocol DataServiceProtocol: Equatable {
    func getCourses() -> AnyPublisher<[Course], Error>
}


class ProductionDataService: DataServiceProtocol {
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func getCourses() -> AnyPublisher<[Course], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Course].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Equatable
    static func == (lhs: ProductionDataService, rhs: ProductionDataService) -> Bool {
        return lhs.url == rhs.url
    }
}


class MockDataService<T>: DataServiceProtocol where T: MockDataProtocol {
    
    let mockCourses: [Course]
    
    init(mockData: T) {
        self.mockCourses = mockData.courses
    }
    
    func getCourses() -> AnyPublisher<[Course], Error> {
        Just(mockCourses)
            .tryMap({ courses in
                guard !courses.isEmpty else {
                    throw URLError(.badServerResponse)
                }
                return courses
            })
            .eraseToAnyPublisher()
    }
    
    // Equatable
    static func == (lhs: MockDataService<T>, rhs: MockDataService<T>) -> Bool {
        return lhs.mockCourses == rhs.mockCourses
    }
    
}
