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
            name: stringsTable.type
        ) {
            for accessor in stringsTable.accessors {
                if accessor.hasArguments {
                    LocalizedStringResourceStringsTableResourceFunctionSnippet(accessor: accessor)
                } else {
                    LocalizedStringResourceStringsTableResourceVariableSnippet(accessor: accessor)
                }
            }
        }
        .spacingMembers()
    }

    var leadingTrivia: Trivia? {
        Trivia(docComment: stringsTable.headerDocumentation)
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: stringsTable.accessLevel.token)
    }
}
