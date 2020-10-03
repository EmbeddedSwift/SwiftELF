public enum RuntimeError: Error {
    case fileNotFound
    case invalidVersion
    case initialization
    case invalidKind
    case couldNotGetHeader
    case couldNotGetClass
    case couldNotGetIdent
    case couldNotFetchStringTableSectionIndex
    case undefined
}
