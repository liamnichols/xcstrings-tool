import StringResource
import SwiftSyntax

extension SourceFile.StringExtension.StringsTableStruct {
    struct ArgumentEnum {
        typealias Case = PlaceholderType

        let stringsTable: SourceFile.StringExtension.StringsTableStruct

        var cases: [Case] {
            Case.allCases
        }

        var type: TokenSyntax {
            .type(.Argument)
        }

        var fullyQualifiedType: [TokenSyntax] {
            stringsTable.fullyQualifiedType + [type]
        }
    }
}
