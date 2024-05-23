import SwiftSyntax

extension SourceFile {
    struct LocalizedStringResourceExtension {
        let sourceFile: SourceFile

        var stringsTableStruct: StringsTableStruct {
            StringsTableStruct(sourceFile: sourceFile)
        }
    }

    var localizedStringResourceExtension: LocalizedStringResourceExtension {
        LocalizedStringResourceExtension(sourceFile: self)
    }
}
