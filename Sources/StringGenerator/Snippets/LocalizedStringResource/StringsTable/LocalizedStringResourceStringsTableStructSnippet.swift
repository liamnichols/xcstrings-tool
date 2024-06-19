import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringResourceStringsTableStructSnippet {
    let stringsTable: SourceFile.LocalizedStringResourceExtension.StringsTableStruct
}

extension LocalizedStringResourceStringsTableStructSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        StructDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: modifiers,
            name: stringsTable.type,
            inheritanceClause: inheritanceClause
        ) {
            for (position, accessor) in stringsTable.accessors.withPosition {
                MemberBlockItemListSyntax {
                    if accessor.hasArguments {
                        LocalizedStringResourceStringsTableResourceFunctionSnippet(accessor: accessor)
                    } else {
                        LocalizedStringResourceStringsTableResourceVariableSnippet(accessor: accessor)
                    }
                }
                .with(\.trailingTrivia, .newlines(2), if: !position.isLast)
            }
        }
    }

    var leadingTrivia: Trivia? {
        Trivia(docComment: stringsTable.headerDocumentation)
    }

    var inheritanceClause: InheritanceClauseSyntax? {
        InheritanceClauseSyntax(.Sendable)
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: stringsTable.accessLevel.token)
    }
}
