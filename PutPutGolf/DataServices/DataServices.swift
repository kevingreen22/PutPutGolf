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
//    func getCourses() -> AnyPublisher<[Course], Error>
    func validateCredentials(user: String, password: String) async throws
    func fetchCourses() async throws -> [Course]
    func post(course: Course, url: URL?, username: String, password: String) async throws
}


class ProductionDataService: DataServiceProtocol {
    init() { }
    
//    func getCourses() -> AnyPublisher<[Course], Error> {
//        AF.request(ProductionURLs.get, method: .get)
//            .validate()
//            .publishDecodable(type: [Course].self)
//            .value()
//            .print("\(type(of: self)).\(#function)-courses retrieved...")
//            .mapError({ $0 as Error })
//            .eraseToAnyPublisher()
//    }
        
    func validateCredentials(user: String, password: String) async throws {
//        let credentials = URLCredential(user: user, password: password, persistence: .forSession)
//        try await withCheckedThrowingContinuation { continuation in
//            AF.request(ProductionURLs.post, method: .post)
//                .authenticate(with: credentials)
//                .response { response in
//                    switch response.result {
//                    case .success():
//                        print("\(type(of: self)).\(#function)-login successful.")
//                        continuation.resume()
//                        
//                    case .failure(let error):
//                        print("\(type(of: self)).\(#function)-\(error.localizedDescription)")
//                        continuation.resume(throwing: ErrorAlert.loginFailed)
//                    }
//                }
//        }
    }
    
    func fetchCourses() async throws -> [Course] {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(ProductionURLs.get, method: .get)
                .responseData { response in
                    switch(response.result) {
                    case let .success(data):
                        do {
                            let coursesData = try JSONDecoder().decode([Course].self, from: data)
                            print("\(type(of: self)).\(#function)-courses retrieved...")
                            continuation.resume(returning: coursesData)
                        } catch {
                            print("\(type(of: self)).\(#function)-\(error.localizedDescription)")
                            continuation.resume(throwing: AlertType.decodeFailure)
                        }
                        
                    case .failure(let reason):
                        switch reason {
                        case .requestAdaptationFailed, .requestRetryFailed, .responseValidationFailed:
                            continuation.resume(throwing: AlertType.fetchFailed)
                        default: continuation.resume(throwing: AlertType.error(error: reason.localizedDescription))
                        }
                    }
                }
        }
    }
    
    func post(course: Course, url: URL?, username: String, password: String) async throws {
        let credentials = URLCredential(user: username, password: password, persistence: .forSession)
        let parameters = try? JSONSerialization.jsonObject(with: try JSONEncoder().encode(course), options: []) as? [String: Any]
        let headers: HTTPHeaders = [
            .accept("application/json")
        ]
        try await withCheckedThrowingContinuation { continuation in
            AF.request(ProductionURLs.post,
                       method: .post,
                       parameters: parameters,
                       headers: headers)
            .authenticate(with: credentials)
            .response { response in
                switch response.result {
                case .success:
                    print(response.error ?? "\(type(of: self)) - No error for post-to-alamoFire.")
                    continuation.resume()
                    
                case .failure(let error):
                    print("\(type(of: self)).\(#function)-\(error.localizedDescription)")
                    continuation.resume(throwing: AlertType.postFailed)
                }
            }
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
    
//    func getCourses() -> AnyPublisher<[Course], Error> {
//        Just(mockCourses)
//            .tryMap({ courses in
//                guard !courses.isEmpty else {
//                    print("\(type(of: self)).\(#function)-\(ErrorAlert.fetchFailed.localizedDescription)")
//                    throw ErrorAlert.fetchFailed
//                }
//                print("\(type(of: self)).\(#function)-mock courses retrieved")
//                return courses
//            })
//            .eraseToAnyPublisher()
//    }
//    func fetchCourses(handler: @escaping ([Course]?) -> Void) throws {
//        print("\(type(of: self)).\(#function)-mock courses retrieved.")
//        handler(mockCourses)
//    }
    
    func validateCredentials(user: String, password: String) async throws {
        print("\(type(of: self)).\(#function)-mock validated credentials.")
    }
    
    func fetchCourses() async throws -> [Course] {
        print("\(type(of: self)).\(#function)-mock courses retrieved.")
        return mockCourses
    }
    
    func post(course: Course, url: URL?, username: String, password: String) async throws {
        print("\(type(of: self)).\(#function)-mock course posted.")
    }
    
    // Equatable
    static func == (lhs: MockDataService<T>, rhs: MockDataService<T>) -> Bool {
        return lhs.mockCourses == rhs.mockCourses
    }
    
}
