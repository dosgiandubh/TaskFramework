//
//  OrderedTests.swift
//  
//
//  Created by dosgiandubh on 07/03/2022.
//

import XCTest
@testable import TaskFramework

final class OrderedTests: XCTestCase {
    
    private final class FakeTask<Input, Output>: Task {
        let executionClosure: (Input) -> TaskResult<Output, Error>

        init(executionClosure: @escaping (Input) -> TaskResult<Output, Error>) {
            self.executionClosure = executionClosure
        }

        func start(with input: Input, completion: @escaping (TaskResult<Output, Error>) -> Void) {
            completion(executionClosure(input))
        }
    }

    func testOrderedRunsTasksFromFirstToSecond() {
        let firstTaskExecuted = expectation(description: "The first task executed")
        let firstTask = FakeTask { (input: Int) -> TaskResult<Int, Error> in
            firstTaskExecuted.fulfill()
            return .success(1)
        }
        let secondTaskExecuted = expectation(description: "The second task executed")
        let secondTask = FakeTask { (input: Int) -> TaskResult<Int, Error> in
            secondTaskExecuted.fulfill()
            return .success(2)
        }

        let chain = firstTask ==> secondTask
        chain.start(with: 1) { _ in }

        wait(for: [firstTaskExecuted, secondTaskExecuted], timeout: 0.1, enforceOrder: true)
    }
}
