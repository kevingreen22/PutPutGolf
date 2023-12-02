//
//  DataServices.swift
//  PutPutGolf
//
//  Created by Kevin Green on 9/22/23.
//

import SwiftUI
import Combine
import Alamofire

struct ProductionURLs {
    static var get = URL(string: "https://try3rg28fg.execute-api.us-west-1.amazonaws.com/live/courses")!
    static var post = URL(string: "https://putputgolf.com/post")!
}

protocol DataServiceProtocol: Equatable {
    func getCourses() -> AnyPublisher<[Course], Error>
    func fetchCourses(handler: @escaping ([Course]?)->Void)
    func post(course: Course, url: URL?, username: String, password: String)
}


class ProductionDataService: DataServiceProtocol {
    
//    let url: URL
//    
//    init(url: URL) {
//        self.url = url
//    }
    
    init() { }
    
    func getCourses() -> AnyPublisher<[Course], Error> {
        AF.request(ProductionURLs.get, method: .get)
            .validate()
            .publishDecodable(type: [Course].self)
            .value()
            .print("\(type(of: self)).\(#function)-courses retrieved...")
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }
    
    func fetchCourses(handler: @escaping ([Course]?) -> Void) {
        AF.request(ProductionURLs.get, method: .get)
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
    
    func post(course: Course, url: URL?, username: String, password: String) {
        
        let credentials = URLCredential(user: username, password: password, persistence: .forSession)
        
        let parameters = try? JSONSerialization.jsonObject(with: try JSONEncoder().encode(course), options: []) as? [String: Any]
        
        let headers: HTTPHeaders = [
                    .accept("application/json")
                ]
        
        AF.request(ProductionURLs.post,
                   method: .post,
                   parameters: parameters,
                   headers: headers)
            .authenticate(with: credentials)
            .response { response in
                print(response.error ?? "No error for post to alamoFire.")
            }
        
    }
    
    // Equatable
    static func == (lhs: ProductionDataService, rhs: ProductionDataService) -> Bool {
        return self == self //lhs.url == rhs.url
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
                    print("\(type(of: self)).\(#function)-\(URLError(.badServerResponse).localizedDescription)")
                    throw URLError(.badServerResponse)
                }
                print("\(type(of: self)).\(#function)-mock courses retrieved")
                return courses
            })
            .eraseToAnyPublisher()
    }
    
    func fetchCourses(handler: @escaping ([Course]?) -> Void) {
        print("\(type(of: self)).\(#function)-mock courses retrieved.")
        handler(mockCourses)
    }
    
    func post(course: Course, url: URL?, username: String, password: String) {
        print("\(type(of: self)).\(#function)-mock course posted.")
    }
    
    // Equatable
    static func == (lhs: MockDataService<T>, rhs: MockDataService<T>) -> Bool {
        return lhs.mockCourses == rhs.mockCourses
    }
    
}
