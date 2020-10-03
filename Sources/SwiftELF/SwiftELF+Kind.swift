#if canImport(Darwin)
import Darwin
import ClibelfMac
#else
import Glibc
import ClibelfLinux
#endif

public extension SwiftELF {
    var kind: Kind? {
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
