#if canImport(Darwin)
import Darwin
import ClibelfMac
#else
import Glibc
import ClibelfLinux
#endif

public extension SwiftELF {
    func printHeader() throws {
        guard let kind = kind, case Kind.elf = kind else {
            throw RuntimeError.invalidKind
        }
        
        let ehdr = UnsafeMutablePointer<GElf_Ehdr>.allocate(capacity: 1)
        guard gelf_getehdr(elf, ehdr) != nil else {
            throw RuntimeError.couldNotGetHeader
        }
        
        let cls = gelf_getclass(elf)
        guard cls != ELFCLASSNONE else {
            throw RuntimeError.couldNotGetClass
        }
        
        guard let _ = elf_getident(elf, nil) else {
            throw RuntimeError.couldNotGetIdent
        }
        
        print("-- ELF Header Begin ---")
        print("e_ident", ehdr.pointee.e_ident)
        print("e_type", ehdr.pointee.e_type)
        print("e_machine", ehdr.pointee.e_machine)
        print("e_version", ehdr.pointee.e_version)
        print("e_entry", ehdr.pointee.e_entry)
        print("e_phoff", ehdr.pointee.e_phoff)
        print("e_shoff", ehdr.pointee.e_shoff)
        print("e_flags", ehdr.pointee.e_flags)
        print("e_ehsize", ehdr.pointee.e_ehsize)
        print("e_phentsize", ehdr.pointee.e_phentsize)
        print("e_shentsize", ehdr.pointee.e_shentsize)
        print("-- ELF Header End ---")
    }
}
