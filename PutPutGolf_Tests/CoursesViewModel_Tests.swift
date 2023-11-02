//
//  CoursesViewModel_Tests.swift
//  PutPutGolf_Tests
//
//  Created by Kevin Green on 11/1/23.
//

import XCTest
@testable import PutPutGolf
import Combine

// Naming Structure: "test_UnitOfWork_StateOfTest_ExpectedBehavior"

// Testing Structure: Given, When, Then


final class CoursesViewModel_Tests: XCTestCase {
    var mockDataService: MockDataService<MockData>!
    var vm: CoursesViewModel!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockDataService = MockDataService(mockData: MockData.instance)
        vm = CoursesViewModel(dataService: mockDataService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockDataService = nil
        vm = nil
    }
    
    
    func test_UnitTestingCoursesViewModel_init_doesSetMockDataService() {
        // Given
        let mockDataService = MockDataService(mockData: MockData.instance)
        let vm = CoursesViewModel(dataService: mockDataService)
        
        // When
        
        // Then
        XCTAssertEqual(vm.dataService as? MockDataService<MockData>, mockDataService)
    }
    
    
    func test_UnitTestingCoursesViewModel_coursesData_hasValues_afterFetchingCourseData() {
        // Given
        // Uses class vars
        
        // When
        let expectation = XCTestExpectation()
        vm.$coursesData
            .sink { data in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.coursesData.count, 0)
    }

    
    func test_UnitTestingCoursesViewModel_selectedCourse_NotNil_afterFetchingCourseData() {
        // Given
        // Uses class vars
        
        // When
        let expectation = XCTestExpectation()
        vm.$coursesData
            .sink { data in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(vm.selectedCourse)
    }
    
    
    func test_UnitTestingCoursesViewModel_mapRegion_notNil_afterFetchingCourseData() {
        // Given
        // Uses class vars
        
        // When
        let expectation = XCTestExpectation()
        vm.$coursesData
            .sink { data in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(vm.mapRegion)
    }
    
    
}
