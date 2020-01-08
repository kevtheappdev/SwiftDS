import XCTest
@testable import SwiftDS

final class SwiftDSTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftDS().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
