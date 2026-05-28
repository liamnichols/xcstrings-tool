import SwiftSyntax
import SwiftSyntaxBuilder

struct StringStringsTableNamespaceEnumSnippet: Snippet {
    let group: SourceFile.StringExtension.StringsTableStruct.NamespaceGroup
    let stringsTable: SourceFile.StringExtension.StringsTableStruct

    var syntax: some DeclSyntaxProtocol {
        EnumDeclSyntax(
            modifiers: modifiers,
            name: group.enumName,
            memberBlock: memberBlock
        )
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: stringsTable.accessLevel.token)
    }

    var memberBlock: MemberBlockSyntax {
        MemberBlockSyntax {
            for (accessor, memberName) in group.members {
                MemberBlockItemListSyntax {
                    if accessor.hasArguments {
                        StringStringsTableResourceFunctionSnippet(
                            accessor: accessor,
                            nameOverride: memberName
                        )
                    } else {
                        StringStringsTableResourceVariableSnippet(
                            accessor: accessor,
                            nameOverride: memberName
                        )
                    }
                }
                .with(\.trailingTrivia, .newlines(2))
            }
        }
    }
}
