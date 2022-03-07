//
//  Isolated.swift
//  TaskFramework
//
//  Created by dosgiandubh on 06/08/2021.
//

/// Wrapper that isolates a wrapped task from any data it receives.
/// It is usually used with a task is needed to be done in the middle of a chain,
/// but wants nothing to start its work.
public final class Isolated<TransientData, NestedTask: Task>:
    Task
where
    NestedTask.Input == Void,
    NestedTask.Output == Void
{
    public let nestedTask: NestedTask

    public init(_ nestedTask: NestedTask) {
        self.nestedTask = nestedTask
    }

    public func start(
        with input: TransientData,
        completion: @escaping (TaskResult<TransientData, NestedTask.Error>) -> Void
    ) {
        nestedTask.start(with: ()) { nestedTaskResult in
            switch nestedTaskResult {
                case .success:
                    completion(.success(input))
                case .cancelled:
                    completion(.cancelled)
                case let .failure(error):
                    completion(.failure(error))
            }
        }
    }
}
