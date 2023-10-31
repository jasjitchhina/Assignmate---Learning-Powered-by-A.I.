// Import XCTest framework for unit testing
import XCTest

// Import the app target for testing, allowing access to internal components
@testable import Assignmate2_1

// Define the main test class that inherits from XCTestCase
final class Assignmate2_1Tests: XCTestCase {
    
    // This method is called before each test method, used for setup
    override func setUpWithError() throws {
        // Put setup code here if needed
    }

    // This method is called after each test method, used for cleanup
    override func tearDownWithError() throws {
        // Put teardown/cleanup code here if needed
    }

    // Example of a functional test case
    func testExample() throws {
        // This is where you write your actual test cases
        // Use XCTest assertions to verify the correctness of your code
        
        // You can use XCTAsssert functions (e.g., XCTAssertEqual, XCTAssertTrue)
        // to check if your code produces the expected results.
        
        // Any test case marked as throws is expected to fail if it encounters an uncaught error.
        // You can use XCTFail() to explicitly fail a test case.
    }

    // Example of a performance test case
    func testPerformanceExample() throws {
        // This is an example of a performance test case
        // You can use this for measuring the execution time of specific code
        
        // The self.measure { } block allows you to measure the time it takes to execute
        // a particular piece of code.
    }
}
