import XCTest
@testable import SwiftELF

final class SwiftELFTests: XCTestCase {
    func test_loadsElf() {
        let elf = try! SwiftELF(at: TestUtilities.elfTestFilePath)
        XCTAssertNotNil(elf)
        elf.end()
    }
    
    func test_getKind() {
        let elf = try! SwiftELF(at: TestUtilities.elfTestFilePath)
        XCTAssertEqual(elf.getKind(), Kind. )
        elf.end()
    }

    static var allTests = [
        ("test_loadsElf", test_loadsElf),
        ("test_getKind", test_getKind),
    ]
}
