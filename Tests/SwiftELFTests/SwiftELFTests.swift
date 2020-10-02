import XCTest
@testable import SwiftELF

final class SwiftELFTests: XCTestCase {
    func testExample() {
        let elf = try! SwiftELF(at: TestUtilities.elfTestFilePath)
        
        XCTAssertNotNil(elf)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
