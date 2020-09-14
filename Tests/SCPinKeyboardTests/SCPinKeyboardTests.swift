import XCTest
@testable import SCPinKeyboard

final class SCPinKeyboardTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SCPinKeyboard().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
