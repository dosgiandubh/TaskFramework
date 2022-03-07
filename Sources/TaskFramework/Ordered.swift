//
//  Ordered.swift
//  TaskFramework
//
//  Created by dosgiandubh on 06/08/2021.
//

import Foundation

/// Basic primitive for linking two tasks together and executing them sequentially.
/// Requires the first task's output be the second task's input to pass a result.
public final class Ordered<First: Task, Second: Task>:
    Task
where
    First.Output == Second.Input,
    First.Error == Second.Error
{
    public let first: First
    public let second: Second

    public init(_ first: First, and second: Second) {
        self.first = first
        self.second = second
    }

    public func start(
        with input: First.Input,
        completion: @escaping (TaskResult<Second.Output, Second.Error>) -> Void
    ) {
        first.start(with: input) { [weak self] firstResult in
            switch firstResult {
                case .cancelled:
                    completion(.cancelled)
                case let .failure(firstTaskFailure):
                    completion(.failure(firstTaskFailure))
                case let .success(firstSuccess):
                    self?.second.start(with: firstSuccess) { secondResult in
                        switch secondResult {
                            case .cancelled:
                                completion(.cancelled)
                            case let .failure(secondTaskFailure):
                                completion(.failure(secondTaskFailure))
                            case let .success(secondSuccess):
                                completion(.success(secondSuccess))
                        }
                }
            }
        }
    }
}
