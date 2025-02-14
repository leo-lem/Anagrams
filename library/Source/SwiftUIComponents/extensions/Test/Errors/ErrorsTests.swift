@testable import Errors
import XCTest

@available(iOS 16, macOS 13, *)
final class ErrorsTests: XCTestCase {
  func testPrintingError() async {
    printError { throw ExampleError.sumTingWong }
    
    await printError {
      try await Task.sleep(for: .seconds(0.1))
      throw ExampleError.sumTingWong
    }
    
    let string = "HELLO"
    let result = printError { string }
    
    XCTAssertEqual(result, string, "The returned result does not equal the input.")
  }
  
  func testMappingError() async {
    do {
      try mapError(to: ExampleError.sumTingElseWong) {
        throw ExampleError.sumTingWong
      }
    } catch {
      XCTAssertEqual(error as? ExampleError, ExampleError.sumTingElseWong, "The error wasn't mapped...")
    }
    
    do {
      try await mapError(to: ExampleError.sumTingElseWong) {
        try await Task.sleep(for: .seconds(0.1))
        throw ExampleError.sumTingWong
      }
    } catch {
      XCTAssertEqual(error as? ExampleError, ExampleError.sumTingElseWong, "The error wasn't mapped...")
    }
  }
  
  func testWritingError() async {
    do {
      var error: ExampleError? = .sumTingWong
      
      try writeError(to: &error) { throw ExampleError.sumTingElseWong }
      
      XCTAssertEqual(error, .sumTingElseWong, "The error wasn't written.")
    } catch {}
    
    do {
      var error: ExampleError? = .sumTingWong
      
      try await writeError(to: &error) {
        try await Task.sleep(for: .seconds(0.1))
        throw ExampleError.sumTingElseWong
      }
      
      XCTAssertEqual(error, .sumTingElseWong, "The error wasn't written.")
    } catch {}
  }
}
