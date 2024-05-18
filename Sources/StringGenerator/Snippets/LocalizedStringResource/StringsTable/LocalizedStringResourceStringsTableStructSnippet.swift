import SwiftSyntax
import SwiftSyntaxBuilder

struct LocalizedStringResourceStringsTableStructSnippet {
    let stringsTable: LocalizedStringResourceTable
}

extension LocalizedStringResourceStringsTableStructSnippet: Snippet {
    var syntax: some DeclSyntaxProtocol {
        StructDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: modifiers,
            name: stringsTable.stringsTable.name.token
        ) {
            for resource in stringsTable.stringsTable.resources {
                resource.declaration(
                    tableName: stringsTable.stringsTable.name.identifier,
                    variableToken: .identifier(stringsTable.stringsTable.name.variableIdentifier),
                    accessLevel: stringsTable.stringsTable.accessLevel.token,
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
        DeclModifierSyntax(name: stringsTable.stringsTable.accessLevel.token)
    }
}
