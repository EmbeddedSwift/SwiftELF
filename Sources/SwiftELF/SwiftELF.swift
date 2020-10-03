#if canImport(Darwin)
import Darwin
import ClibelfMac
#else
import Glibc
import ClibelfLinux
#endif

public enum Kind {
    case none, ar, coff, elf, num
}

public class SwiftELF {
    internal let elf: OpaquePointer
    internal let fd: Int32
    
    public init(at path: String) throws {
        fd = open(path, O_RDONLY)
        guard fd >= 0  else {
            throw RuntimeError.fileNotFound
        }
        guard elf_version(UInt32(EV_CURRENT)) != EV_NONE else {
            throw RuntimeError.invalidVersion
        }
        guard let elf = elf_begin(fd, ELF_C_READ, nil) else {
            throw RuntimeError.initialization
        }
        self.elf = elf
    }
    
    private func end() {
        elf_end(elf)
        close(fd)
    }
    
    deinit {
        end()
    }
}
