//
//  Holder.swift
//  TaskFramework
//
//  Created by dosgiandubh on 06/08/2021.
//

/// Wrapper that can keep a data that its wrapped task does not need and can pass it further.
/// It is usually used in cases the task at the middle of a chain needs something that the previous tasks can not provide.
public final class Holder<TransientData, Nested: Task>: Task {
    public let nestedTask: Nested

    public init(wrapping nestedTask: Nested) {
        self.nestedTask = nestedTask
    }

    /// Takes a pair of objects, a transient data that is passed through and a data for its wrapped task, and starts the wrapped task.
    /// - Parameters:
    ///   - input: Tuple with a transient data and an input for the wrapped task
    ///   - completion: Completion that will be called as the task gets completed
    public func start(
        with input: (TransientData, Nested.Input),
        completion: @escaping (TaskResult<(TransientData, Nested.Output), Nested.Error>) -> Void
    ) {
        nestedTask.start(with: input.1) { result in
            switch result {
                case let .success(nestedOutput):
                    completion(.success((input.0, nestedOutput)))
                case .cancelled:
                    completion(.cancelled)
                case let .failure(nestedFailure):
                    completion(.failure(nestedFailure))
            }
        }
    }
}
