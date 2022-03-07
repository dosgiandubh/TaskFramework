//
//  TaskResult.swift
//  TaskFramework
//
//  Created by dosgiandubh on 06/08/2021.
//

public enum TaskResult<T, Error> where Error: Swift.Error {
    case success(T)
    case cancelled
    case failure(Error)

    public init(from result: Result<T, Error>) {
        switch result {
            case let .success(data):
                self = .success(data)
            case let .failure(error):
                self = .failure(error)
        }
    }
}
