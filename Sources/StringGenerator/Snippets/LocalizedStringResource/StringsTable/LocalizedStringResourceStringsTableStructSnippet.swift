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
            for resource in stringsTable.resources {
                resource.declaration(
                    tableName: stringsTable.sourceFile.tableName,
                    variableToken: .identifier(stringsTable.sourceFile.tableVariableIdentifier),
                    accessLevel: stringsTable.accessLevel.token,
                    isLocalizedStringResource: true
                )
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
