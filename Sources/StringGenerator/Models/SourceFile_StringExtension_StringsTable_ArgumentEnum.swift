import SwiftSyntax

extension SourceFile.StringExtension.StringsTableStruct {
    struct ArgumentEnum {
        enum Case: String, CaseIterable {
            case object, int, uint, double, float
        }

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

extension SourceFile.StringExtension.StringsTableStruct.ArgumentEnum.Case {
    var name: TokenSyntax {
        .identifier(rawValue)
    }

    var parameters: [TokenSyntax] {
        switch self {
        case .object:
            [.type(.String)]
        case .int:
            [.type(.Int)]
        case .uint:
            [.type(.UInt)]
        case .float:
            [.type(.Float)]
        case .double:
            [.type(.Double)]
        }
    }
}
