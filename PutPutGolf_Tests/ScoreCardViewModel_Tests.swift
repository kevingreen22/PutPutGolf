//
//  ScoreCardViewModel_Tests.swift
//  PutPutGolf_Tests
//
//  Created by Kevin Green on 11/2/23.
//

import XCTest
@testable import PutPutGolf
import Combine

final class ScoreCardViewModel_Tests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    @MainActor func test_UnitTestScoreCardViewModel_initTotals_resumingGame() {
        // Given
        let mock = MockData.instance
        
        // When
        let isResumingGame = true
        var vm = ScoreCardViewModel(course: mock.courses.first!, players: mock.players, isResumingGame: isResumingGame)
        
        // Then
        XCTAssertEqual(vm.totals.count, mock.players.count)
        XCTAssertEqual(vm.finalTotals.count, mock.players.count)
    }
    
    
    @MainActor func test_UnitTestScoreCardViewModel_initTotals_newGame() {
        // Given
        let mock = MockData.instance
        for player in mock.players {
            player.scores = Array(repeating: "", count: mock.courses.first!.holes.count)
            player.challengeScores = Array(repeating: "", count: mock.courses.first!.challenges.count)
        }
        
        // When
        let isResumingGame = false
        var vm = ScoreCardViewModel(course: mock.courses.first!, players: mock.players, isResumingGame: isResumingGame)
        
        // Then
        XCTAssertEqual(vm.totals.count, mock.players.count)
        XCTAssertEqual(vm.finalTotals.count, mock.players.count)
    }
    
    
    @MainActor func test_UnitTestScoreCardViewModel_setGameIsCompletedTrue() {
        // Given
        let mock = MockData.instance
        var vm = ScoreCardViewModel(course: mock.courses.first!, players: mock.players)
        
        // When
        let expectation = XCTestExpectation()
        vm.$players
            .sink { players in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 5)
        print(mock.players.first!.scores)
        print(mock.players.first!.challengeScores)
        XCTAssertTrue(vm.isGameCompleted)
    }

}
