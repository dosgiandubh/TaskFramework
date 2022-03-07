//
//  Task+Chaining.swift
//  TaskFramework
//
//  Created by dosgiandubh on 06/08/2021.
//

infix operator ==>: AdditionPrecedence

/// Presents the simpliest way to link two Task tasks. Returns a pair of two tasks.
/// Example: `A() => B()`
/// `A` takes a data at start and produces something that needs `B`.
/// So the returned pair will take a data for the first task and return a result from the second one.
/// - Parameters:
///   - lhs: First task
///   - rhs: Second task
public func ==> <L: Task, R: Task>(lhs: L, rhs: R) -> Ordered<L, R>
    where L.Output == R.Input {
        return Ordered(lhs, and: rhs)
}

/// Presents the simpliest way to link two Task tasks. Returns a pair of two tasks.
/// Example: `A() => B()`
/// `A` takes a data at start and produces something that needs `B`.
/// So the returned pair will take a data for the first task and return a result from the second one.
/// - Parameters:
///   - lhs: First task
///   - rhs: Second task
public func ==> <L: Task, R: Task>(lhs: L, rhs: R) -> Ordered<L, R>
    where L.Output == R.Input, L.Output == Void {
        return Ordered(lhs, and: rhs)
}

/// Provides a way to pass some data which is needed for the second task but not for the first one.
/// Is used when the second task needs to get something + the first task's output.
/// For instance: `FetchConfirmationData` takes an operation id and returns a metadata for the cover,
/// `ShowConfirmCover` takes a container and the metadata fetched by the first task. So the input of the pair will be
/// a container (for `ShowConfirmCover`) and an operation id (for `FetchConfirmationData`).
/// - Parameters:
///   - lhs: First task
///   - rhs: Second task
public func ==> <T, L: Task, R: Task>(lhs: L, rhs: R) -> Ordered<Holder<T, L>, R>
    where R.Input == (T, L.Output) {
        return Ordered(Holder<T, L>(wrapping: lhs), and: rhs)
}

/// Provides a way to make input of the pair simpler if the first task needs nothing to get started but the second task needs something that the first one does not produce
/// For instance: `GetPublicKey() ==> Login()`
/// `GetPublicKey` does not need anything and returns a data needed for `Login`,
///  at the same time `Login` needs for work user's credentials and the data from `GetPublicKey`.
///   In that case input of the pair will be only user's credentials because the first task needs no data.
/// - Parameters:
///   - lhs: First task
///   - rhs: Second task
public func ==> <T, L: Task, R: Task>(lhs: L, rhs: R) -> Ordered<CompactHolder<T, L>, R>
    where R.Input == (T, L.Output), L.Input == Void {
        return Ordered(CompactHolder<T, L>(wrapping: lhs), and: rhs)
}

/// Provides a way to chain tasks in case the second task does not affect the current data.
/// In this case the second task will be executed and on a successful completion will pass
/// the unmodified data further.
/// For instance: `TransferByPhone() ==> ConfirmTransaction()`
/// - Parameters:
///   - lhs: First task
///   - rhs: Second task
public func ==> <L: Task, R: Task>(lhs: L, rhs: R) -> Ordered<L, Isolated<L.Output, R>>
    where R.Input == Void, R.Output == Void {
        return Ordered(lhs, and: Isolated(rhs))
}

/// Provides a way to chain tasks in case the first task does not affect the current data.
/// This takes the data needed for the second task, executes the first one, and then starts the second task with the given data.
/// For instance: `CheckConnectivity() ==> LoginByEmailAndPassword()`
/// - Parameters:
///   - lhs: First task
///   - rhs: Second task
public func ==> <L: Task, R: Task>(lhs: L, rhs: R) -> Ordered<Isolated<R.Input, L>, R>
    where L.Input == Void, L.Output == Void {
        return Ordered(Isolated(lhs), and: rhs)
}
