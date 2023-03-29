//
//  ConcurrencyTests.swift
//  GithubExplorerTests
//
//  Created by Bogdan Chornobryvets on 29.03.2023.
//

import XCTest
@testable import GithubExplorer

final class ConcurrencyTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testAsyncSemaphore() async throws {
        //given
        let semaphore = AsyncSemaphore(count: 2)
        let results = CompletionResults()
        
        //when
        Task {
            await semaphore.wait()
            try await Task.sleep(nanoseconds: 200_000)
            await results.completeTask(1)
            await semaphore.release()
        }
        try await Task.sleep(nanoseconds: 10_000)
        Task {
            await semaphore.wait()
            try await Task.sleep(nanoseconds: 200_000)
            await results.completeTask(2)
            await semaphore.release()
        }
        try await Task.sleep(nanoseconds: 10_000)
        Task {
            await semaphore.wait()
            try await Task.sleep(nanoseconds: 200_000)
            await results.completeTask(3)
            await semaphore.release()
        }
        
        try await Task.sleep(nanoseconds: 300_000)
        
        let isCompleted1 = await results.isCompleted(task: 1)
        let isCompleted2 = await results.isCompleted(task: 2)
        let isCompleted3 = await results.isCompleted(task: 3)
        
        //then
        XCTAssertTrue(isCompleted1)
        XCTAssertTrue(isCompleted2)
        XCTAssertFalse(isCompleted3)
        
        try await Task.sleep(nanoseconds: 300_000)
        let isCompleted3_1 = await results.isCompleted(task: 3)
        XCTAssertTrue(isCompleted3_1)
        
    }
    
    actor CompletionResults {
        var completedTasks: Set<UInt> = []
        
        func completeTask(_ number: UInt) {
            completedTasks.insert(number)
        }
        
        func isCompleted(task number: UInt) -> Bool {
            completedTasks.contains(number)
        }
    }
    
}
