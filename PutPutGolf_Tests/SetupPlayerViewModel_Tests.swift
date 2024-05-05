//
//  SetupPlayerViewModel_Tests.swift
//  PutPutGolf_Tests
//
//  Created by Kevin Green on 11/2/23.
//

import XCTest
@testable import PutPutGolf
import Combine

final class SetupPlayerViewModel_Tests: XCTestCase {
    var vm: SetupPlayers.ViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vm = SetupPlayers.ViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        vm = nil
    }
    
    
    func test_UnitTestingSetupPlayerViewModel_init_didSetValues() {
        // Given

        // When
        
        // Then
        XCTAssertNotNil(vm.newPlayers)
        XCTAssertTrue(vm.newPlayers.isEmpty)
        XCTAssertNil(vm.profileImage)
        XCTAssertEqual(vm.playerName, "")
        XCTAssertNotNil(vm.pickedColor)
    }
    
    
    func test_UnitTestingSetupPlayerViewModel_createNewPlayer_didPassRestrictions() {
        // Given
        vm.playerName = "Kevin"
        vm.profileImage = UIImage(systemName: "person")
        vm.textFieldDidSubmit = true
        
        // When
        let expectation = XCTestExpectation()
        vm.$newPlayers
            .sink { player in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 8)
        XCTAssertGreaterThan(vm.newPlayers.count, 0)
        XCTAssertEqual(vm.playerName, "")
        XCTAssertNil(vm.profileImage)
    }
    
    
    func test_UnitTestingSetupPlayerViewModel_createNewPlayer_didNotPassRestrictions() {
        // Given
        guard vm != nil else { XCTFail("\(#function)-XCTest error, viewModel is nil"); return }
        let player = NewPlayer(name: "kevin", color: .red)
        vm?.newPlayers.append(player)
        vm!.playerName = "Kevin"
        vm!.profileImage = UIImage(systemName: "person")
        vm!.textFieldDidSubmit = true
        
        // When
        let expectation = XCTestExpectation()
        vm!.$textFieldDidSubmit
            .sink { didSubmit in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 8)
        XCTAssertEqual(vm!.newPlayers.count, 1)
        XCTAssertNotEqual(vm!.playerName, "")
    }

    
    func test_UnitTestingSetupPlayerViewModel_createPlayers_didCreate() {
        // Given
        let course = MockData.instance.courses.first!
        vm.newPlayers = [
            NewPlayer(name: "Kevin", color: .red),
            NewPlayer(name: "Nell", color: .pink),
            NewPlayer(name: "Jeremy", color: .black)
        ]        
        
        // When
        let players = vm.createPlayers(on: course)
        
        // Then
        XCTAssertEqual(players.count, vm.newPlayers.count)
    }
    

}
