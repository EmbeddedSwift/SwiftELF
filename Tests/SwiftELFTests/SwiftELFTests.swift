import XCTest
@testable import SwiftELF

final class SwiftELFTests: XCTestCase {
    
    var sut: SwiftELF!
    
    override func setUp() {
        super.setUp()
        sut = try! SwiftELF(at: TestUtilities.elfTestFilePath)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
        
    func test_loads_elf() {
        XCTAssertNotNil(sut)
    }
    
    func test_gets_kind() {
        XCTAssertEqual(sut.kind, Kind.elf)
    }
    
    func test_prints_header() {
        try! sut.printHeader()
    }

    static var allTests = [
        ("test_loads_elf", test_loads_elf),
        ("test_gets_kind", test_gets_kind),
        ("test_prints_header", test_prints_header),
    ]
}
