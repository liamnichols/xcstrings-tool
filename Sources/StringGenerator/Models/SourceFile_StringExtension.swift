import SwiftSyntax

extension SourceFile {
    /// An extension used to contain a struct that represents the strings table
    struct StringExtension {
        let sourceFile: SourceFile

        var stringsTableStruct: StringsTableStruct {
            StringsTableStruct(sourceFile: sourceFile)
        }
    }

    var stringExtension: StringExtension {
        StringExtension(sourceFile: self)
    }
}
