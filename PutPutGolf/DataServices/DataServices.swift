//
//  DataServices.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/22/23.
//

import SwiftUI
import Combine

protocol DataServiceProtocol {
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
}


class MockDataService<T>: DataServiceProtocol where T: MockDataProtocol {
    let mockCourses: [Course]
    let mockPlayers: [Player]
    
    init(mockData: T) {
        self.mockCourses = mockData.courses
        self.mockPlayers = mockData.players
    }
    
    func getCourses() -> AnyPublisher<[Course], Error> {
        Just(mockCourses)
            .tryMap({ $0 })
            .eraseToAnyPublisher()
    }
}
