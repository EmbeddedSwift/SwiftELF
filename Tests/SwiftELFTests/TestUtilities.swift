import Foundation

struct TestUtilities {
    static var elfTestFilePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("../Files/testfile-phdrs.elf").path
}
