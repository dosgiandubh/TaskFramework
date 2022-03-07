//
//  Task.swift
//  TaskFramework
//
//  Created by dosgiandubh on 06/08/2021.
//

/// Type representing an Task task that can be chained with others
public protocol Task: AnyObject {
    associatedtype Input
    associatedtype Output
    associatedtype Error: Swift.Error

    /// Starts doing its work taking all needed parameters
    /// - Parameters:
    ///   - with: An object needed to start the task's job
    ///   - completion: Closure that will be called as the task gets completed
    func start(with: Input, completion: @escaping (TaskResult<Output, Error>) -> Void)
}
