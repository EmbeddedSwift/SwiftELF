#if canImport(Darwin)
import Darwin
import ClibelfMac
#else
import Glibc
import ClibelfLinux
#endif

enum RuntimeError: Error {
    case fileNotFound
    case invalidVersion
    case initialization
}

enum Kind {
    case none, ar, coff, elf, num
}

struct SwiftELF {
    private let elf: OpaquePointer
    private let fd: Int32
    
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
    
    public func end() {
        elf_end(elf)
        close(fd)
    }
    
    public func getKind() -> Kind? {
        let kind = elf_kind(elf)
        if kind == ELF_K_NONE {
            return Kind.none
        } else if kind == ELF_K_AR {
            return .ar
        } else if kind == ELF_K_COFF {
            return .coff
        } else if kind == ELF_K_ELF {
            return .elf
        } else if kind == ELF_K_NUM {
            return .num
        }
        return nil
    }
}
