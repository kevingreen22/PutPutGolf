//
//  MockDataService_Tests.swift
//  PutPutGolf_Tests
//
//  Created by Kevin Green on 11/1/23.
//

import XCTest
@testable import PutPutGolf
import Combine

final class MockDataService_Tests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables.removeAll()
    }

    
    func test_MockDataService_init_doesSetCoursesCorrectly() {
        // Given
        let mockData = MockData.instance
        let dataService = MockDataService(mockData: mockData)
        
        // When
        
        // Then
        XCTAssertEqual(dataService.mockCourses, mockData.courses)
    }
    
    
//    func test_MockDataService_getCourses_doesReturnValues() {
//        // Given
//        let mockData = MockData.instance
//        let dataService = MockDataService(mockData: mockData)
//        
//        // When
//        var items: [Course] = []
//        let expectation = XCTestExpectation()
//        dataService.getCourses()
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case.finished:
//                    expectation.fulfill()
//                case .failure(let error):
//                    XCTFail("\(error)")
//                }
//            }, receiveValue: { courses in
//                items = courses
//            })
//            .store(in: &cancellables)
//        
//        // Then
//        wait(for: [expectation], timeout: 5)
//        XCTAssertEqual(items.count, dataService.mockCourses.count)
//    }
    
    
//    func test_MockDataService_getCourses_doesFail() {
//        // Given
//        let mockData = MockData.instance
//        let coursesToSave = mockData.courses
//        mockData.courses = [] // removing the courses so the test fails properly.
//        let dataService = MockDataService(mockData: mockData)
//        
//        // When
//        var items: [Course] = []
//        let expectationError = XCTestExpectation(description: "Does throw error")
//        let expectationURLError = XCTestExpectation(description: "Does throw URLError(.badServerResponse)")
//        
//        dataService.getCourses()
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case.finished:
//                    XCTFail()
//                    
//                case .failure(let error):
//                    expectationError.fulfill()
//                    
//                    if error as? URLError == URLError(.badServerResponse) {
//                        expectationURLError.fulfill()
//                    }
//                }
//            }, receiveValue: { courses in
//                items = courses
//            })
//            .store(in: &cancellables)
//        
//        // Then
//        wait(for: [expectationError, expectationURLError], timeout: 5)
//        XCTAssertEqual(items.count, dataService.mockCourses.count)
//        mockData.courses = coursesToSave // adding the courses back because mockData is a singleton.
//    }


}
