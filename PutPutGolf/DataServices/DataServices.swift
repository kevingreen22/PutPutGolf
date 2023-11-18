//
//  DataServices.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/22/23.
//

import SwiftUI
import Combine
import Alamofire

protocol DataServiceProtocol: Equatable {
    func getCourses() -> AnyPublisher<[Course], Error>
    func fetchCourses(handler: @escaping ([Course]?)->Void)
}


class ProductionDataService: DataServiceProtocol {
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func getCourses() -> AnyPublisher<[Course], Error> {
        AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: [Course].self)
            .value()
            .print("\(type(of: self)).\(#function)-courses retrieved...")
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()

    }
    
    func fetchCourses(handler: @escaping ([Course]?) -> Void) {
        AF.request(url, method: .get)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    do {
                        let coursesData = try JSONDecoder().decode([Course].self, from: data)
                        print("\(type(of: self)).\(#function)-courses retrieved...")
                        handler(coursesData)
                    } catch {
                        print("\(type(of: self)).\(#function)-\(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("\(type(of: self)).\(#function)-\(error.localizedDescription)")
                }
            }
    }
    
    
    func setCourses(url: URL, username: String, password: String) {
        // "https://putputgolf.com/post" ??
        let credentials = URLCredential(user: username, password: password, persistence: .forSession)
        
        let parameters: Parameters = [
            "category": "Movies", 
            "genre": "Action"
        ]
        
        let headers: HTTPHeaders = [
                    .accept("application/json")
                ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers)
            .authenticate(with: credentials)
            .response { response in
                print(response.error ?? "No error for post to alamoFire.")
            }
        
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
    
    func fetchCourses(handler: @escaping ([Course]?) -> Void) {
        print("\(type(of: self)).\(#function)-mock courses retrieved")
        handler(mockCourses)
    }
    
    // Equatable
    static func == (lhs: MockDataService<T>, rhs: MockDataService<T>) -> Bool {
        return lhs.mockCourses == rhs.mockCourses
    }
    
}
