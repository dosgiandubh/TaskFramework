# TaskFramework

## Motivation

The main idea of that framework was to create a light-weight solution for chaining a sequence of asynchronous tasks. It should have solved a few problems that I met working with `OperationQueue`: passing a result from one task to the next one checked at compile time, a convenient and simple interface to start and finish a sequence, and allows developers to reuse some components.

## Goals

1. Ability to reuse components;
2. Compile time checking;
3. Easy mocking for tests and debugging;
4. Avoiding any manual actions to dispose a sequence on `deinit`;
5. Ability to get access to any elements of a sequence;
6. As simple implementation as possible.

## Example

Creating a sequence of tasks could look like the following:

```swift
let sequence = Task1() ==> Task2() ==> Task3() ==> Task4()
let inputData = Task1.Input()

sequence.start(inputData) { finalResult in
    switch finalResult {
        case let .success(model):
            // Processing a received model
        case let .failure(error):
            // Handling an error
        case .cancelled:
            // Handling the case if the user has cancelled the operation
    }
}
```

Every task declares what data it needs and what it produces as a result, and joining them in one sequence requires task's output to be the same as the next one's input. The created `sequence` itself is a task with own input and output, calculated by the first and the last tasks. In this example, `sequence`'s input is equal to `Task1`'s input, and `sequence`'s output matches `Task4`'s output.

## Base elements

Every task conforms to `Task` protocol:

```swift
protocol Task: AnyObject {
    associatedtype Input
    associatedtype Output
    associatedtype Error: Swift.Error

    func start(with: Input, completion: @escaping (TaskResult<Output, Error>) -> Void)
}
```

`start` method is the key part of the task's interface, which does the main job. It gets `Input`, the result of the previous task, and a `completion` which should be called as the task finishes. It will return `Output` which will be sent to the next task (in case the task was completed successfully).

## Usage

Because every sequence of `Task` tasks is `Task` as well, any sequence can be joined to other tasks and sequences. Also, a task can wrap another task (or a sequence), so there were the following patterns:

1. Simple tasks — do specific actions;
2. Retry — Task that wraps another task and tries to re-run it on a failure;
3. Encrypting — Task that encrypts a given object and sends to the next task;
4. Flow customization — Task that takes two other tasks and runs one of them depending on its condition;
5. Splitting threads of data — Task that takes data, which should pass by another task, and hold it for a time.
