//
//  CompactHolder.swift
//  TaskFramework
//
//  Created by dosgiandubh on 06/08/2021.
//

/// Wrapper that can keep a data that its wrapped task does not need and can pass it further.
/// It is usually used in cases the task at the middle of a chain needs something that the previous tasks cannot provide.
/// Unlike `Holder` assumes that a nested task needs nothing at start
public final class CompactHolder<TransientData, Nested: Task>: Task where Nested.Input == Void {
    public let nestedTask: Nested

    public init(wrapping nestedTask: Nested) {
        self.nestedTask = nestedTask
    }

    public func start(
        with input: TransientData,
        completion: @escaping (TaskResult<(TransientData, Nested.Output), Nested.Error>) -> Void
    ) {
        nestedTask.start(with: ()) { result in
            switch result {
                case let .success(nestedOutput):
                    completion(.success((input, nestedOutput)))
                case .cancelled:
                    completion(.cancelled)
                case let .failure(nestedFailure):
                    completion(.failure(nestedFailure))
            }
        }
    }
}
