#if canImport(Darwin)
import Darwin
import ClibelfMac
#else
import Glibc
import ClibelfLinux
#endif

enum RuntimeError: Error {
    case initialization
}

struct SwiftELF {
    private let elf: Any
    
    public init(at path: String) throws {
        let fd = open(path, O_RDONLY)
        elf_version(UInt32(EV_CURRENT))
        guard let elf = elf_begin(fd, ELF_C_READ, nil) else {
            throw RuntimeError.initialization
        }
        self.elf = elf
    }
}
