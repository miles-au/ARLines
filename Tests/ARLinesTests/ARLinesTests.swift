import XCTest
@testable import ARLines

final class ARLinesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ARLines().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
