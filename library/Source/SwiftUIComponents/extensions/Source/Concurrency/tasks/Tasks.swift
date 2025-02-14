//	Created by Leopold Lemmermann on 31.10.22.

/// A collection of tasks, which primarily handles cancelling tasks on deinitialization
public class Tasks<Key: Hashable> {
  var tasksWithID = [Key: CancellableTask](),
      anonymousTasks = [CancellableTask]()

  public init() {}

  deinit {
    for task in anonymousTasks { task.cancel() }
    for task in tasksWithID.values { task.cancel() }
  }
}

// anonymous tasks
public extension Tasks {
  /// Add a task anonymously (e.g., when you don' t care about manually stopping it)
  /// - Parameter tasks: Variadic argument of tasks.
  func add(_ tasks: CancellableTask...) { add(tasks) }

  /// Add a task anonymously (e.g., when you don' t care about manually stopping it)
  /// - Parameter tasks: An array of tasks.
  func add(_ tasks: [CancellableTask]) {
    for task in tasks { anonymousTasks.append(task) }
  }
}

// id tasks
 public extension Tasks {
  subscript(_ key: Key) -> CancellableTask? {
    get { tasksWithID[key] }
    set {
      tasksWithID[key]?.cancel()
      tasksWithID[key] = newValue
    }
  }
 }
