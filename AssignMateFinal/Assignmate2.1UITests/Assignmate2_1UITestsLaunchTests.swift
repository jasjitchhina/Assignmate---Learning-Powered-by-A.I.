import XCTest

// Define the main UI test launch class that inherits from XCTestCase
final class Assignmate2_1UITestsLaunchTests: XCTestCase {

    // Override the runsForEachTargetApplicationUIConfiguration variable to ensure this test runs for each UI configuration
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    // This method is called before the test cases to set up initial configurations
    override func setUpWithError() throws {
        // Set the "continueAfterFailure" flag to false to stop testing immediately after a failure
        continueAfterFailure = false
    }

    // This method is a UI test case for app launch
    func testLaunch() throws {
        // Create an instance of XCUIApplication to represent the app
        let app = XCUIApplication()
        
        // Launch the app
        app.launch()

        // You can insert steps here to perform actions after app launch but before taking a screenshot.
        // For example, you can log in with a test account or navigate to a specific screen in the app.

        // Capture a screenshot of the launch screen
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
