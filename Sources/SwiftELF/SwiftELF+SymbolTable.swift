#if canImport(Darwin)
import Darwin
import ClibelfMac
#else
import Glibc
import ClibelfLinux
#endif

public extension SwiftELF {
    enum SymbolTableType {
        case symtab, dynsym, unknown
    }
    
    typealias SymbolTable = [String: Int]

    func getSymbolTables() throws -> [SymbolTableType: SymbolTable] {
        var symbols = [SymbolTableType: SymbolTable]()
        
        let ehdr = UnsafeMutablePointer<GElf_Ehdr>.allocate(capacity: 1)
        guard gelf_getehdr(elf, ehdr) != nil else {
            throw RuntimeError.couldNotGetHeader
        }
        
        var scn: OpaquePointer? = nil
        let shdr = UnsafeMutablePointer<GElf_Shdr>.allocate(capacity: 1)
        var data = UnsafeMutablePointer<Elf_Data>.allocate(capacity: 1)
        var count: UInt = 0

        repeat {
            scn = elf_nextscn(elf, scn)
            gelf_getshdr(scn, shdr)
            
            if shdr.pointee.sh_type == SHT_SYMTAB || shdr.pointee.sh_type == SHT_DYNSYM {
                data = elf_getdata(scn, nil)
                count = shdr.pointee.sh_size / shdr.pointee.sh_entsize

                symbols[{
                    switch Int32(shdr.pointee.sh_type) {
                    case SHT_SYMTAB:
                        return .symtab
                    case SHT_DYNSYM:
                        return .dynsym
                    default:
                        return .unknown // this should never happen
                    }
                }()] = {
                    var values = SymbolTable()
                    for i in 0 ..< count {
                        var sym = UnsafeMutablePointer<GElf_Sym>.allocate(capacity: 1)
                        sym = gelf_getsym(data, Int32(i), sym)
                        values[String(cString: elf_strptr(elf, Int(shdr.pointee.sh_link), Int(sym.pointee.st_name)))] = Int(sym.pointee.st_value.description)
                    }
                    return values
                }()
            }

        } while elf_nextscn(elf, scn) != nil

        return symbols
    }
}
