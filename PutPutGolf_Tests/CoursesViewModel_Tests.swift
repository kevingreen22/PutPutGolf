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
    var vm: CoursesMap.ViewModel!
    var cancellables = Set<AnyCancellable>()
    
    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockDataService = MockDataService(mockData: MockData.instance)
        vm = CoursesMap.ViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockDataService = nil
        vm = nil
    }
    
    
    @MainActor func test_UnitTestingCoursesViewModel_init_doesSetMockDataService() {
        // Given
        let mockCourses = MockDataService(mockData: MockData.instance).mockCourses
        let vm = CoursesMap.ViewModel()
        
        // When
        
        // Then
        XCTAssertEqual(vm.coursesData, mockCourses)
    }
    
    
    @MainActor func test_UnitTestingCoursesViewModel_selectedCourse_NotNil_afterFetchingCourseData() {
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
    
    
    @MainActor func test_UnitTestingCoursesViewModel_mapRegion_notNil_afterFetchingCourseData() {
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
