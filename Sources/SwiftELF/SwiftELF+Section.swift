#if canImport(Darwin)
import Darwin
import ClibelfMac
#else
import Glibc
import ClibelfLinux
#endif

public extension SwiftELF {
    func getSectionNames() throws -> [String: Int] {
        guard elf_kind(elf) == ELF_K_ELF else {
            throw RuntimeError.invalidKind
        }
        
        let shstrndx = UnsafeMutablePointer<size_t>.allocate(capacity: 1)
        
        guard elf_getshdrstrndx(elf, shstrndx) == 0 else {
            throw RuntimeError.couldNotFetchStringTableSectionIndex
        }
        
        var sectionsNames = [String: Int]()
        var scn: OpaquePointer? = nil
        let shdr = UnsafeMutablePointer<GElf_Shdr>.allocate(capacity: 1)
        repeat {
            scn = elf_nextscn(elf, scn)

            if gelf_getshdr(scn, shdr) != shdr {
                throw RuntimeError.undefined // todo: add proper error
            }

            guard let name = elf_strptr(elf, shstrndx.pointee, Int(shdr.pointee.sh_name)) else {
                throw RuntimeError.undefined
            }

            sectionsNames[String(cString: name)] = elf_ndxscn(scn)
            
        } while elf_nextscn(elf, scn) != nil
        
        scn = elf_getscn(elf, shstrndx.pointee)
        
        guard scn != nil else {
            throw RuntimeError.undefined
        }
        
        guard gelf_getshdr(scn, shdr) == shdr else {
            throw RuntimeError.undefined
        }
        
        return sectionsNames
    }
}
