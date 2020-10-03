import XCTest
@testable import SwiftELF

final class SwiftELFTests: XCTestCase {
    
    var sut: SwiftELF!
    
    override func setUp() {
        super.setUp()
        XCTAssertNoThrow(sut = try SwiftELF(at: TestFiles.elfLinuxLibX86.path))
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
        XCTAssertNoThrow(try sut.printHeader())
    }
    
    func test_gets_sectionNames() {
        let sectionNames = try! sut.getSectionNames()
        XCTAssertEqual(sectionNames, TestFiles.elfLinuxLibX86.sectionData)
    }
    
    func test_get_symbolTable() {
        let symbolTables = try! sut.getSymbolTables()
        XCTAssertEqual(symbolTables, TestFiles.elfLinuxLibX86.symbolTables)
    }

    static var allTests = [
        ("test_loads_elf", test_loads_elf),
        ("test_gets_kind", test_gets_kind),
        ("test_prints_header", test_prints_header),
    ]
}
