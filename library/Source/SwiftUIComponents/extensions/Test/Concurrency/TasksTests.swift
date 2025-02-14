//	Created by Leopold Lemmermann on 14.11.22.

@testable import Concurrency
import XCTest

@available(iOS 16, macOS 13, *)
final class TasksTests: XCTestCase {
  private var tasks = Tasks()

  override func setUp() {
    tasks = Tasks()
  }

  func testAddingAnonymousTask() {
    tasks.add(Task<Void, Never> { print("Task executed") })

    XCTAssertTrue(tasks.anonymousTasks.count == 1, "Task was not inserted.")
  }

  func testAddingTaskWithID() {
    tasks["task1"] = Task<Void, Never> { print("Task executed") }

    XCTAssertNotNil(tasks.tasksWithID["task1"], "Task was not added at key.")
  }

  func testRemovingTaskWithID() {
    tasks["task1"] = Task<Void, Never> { print("Task executed") }
    tasks["task1"] = nil

    XCTAssertNil(tasks.tasksWithID["task1"], "Task was not removed.")
  }

  func testTasksAreCancelledOnDeinit() {
    let task = Task<Void, Never> { await sleep(for: .seconds(0.1)) }

    tasks.add(task)
    tasks["task1"] = task

    tasks = Tasks()

    XCTAssertTrue(task.isCancelled, "Task was not cancelled in deinit.")
  }
}
