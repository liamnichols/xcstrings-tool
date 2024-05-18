import SwiftSyntax
import SwiftSyntaxBuilder

/// The struct declaration that describes the strings table being generated
struct StringStringsTableStructSnippet: Snippet {
    let stringsTable: StringsTable

    var syntax: some DeclSyntaxProtocol {
        // /// headerdoc
        // public struct Localizable { ... }
        StructDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: modifiers,
            name: stringsTable.name.token
        ) {
            // enum BundleDescription { ... }
            StringStringsTableBundleDescriptionEnumSnippet(bundleDescription: BundleDescription(stringsTable: stringsTable))
                .syntax
                .with(\.trailingTrivia, .newlines(2))

            // enum Argument { ... }
            StringStringsTableArgumentEnumSnippet(argument: Argument(stringsTable: stringsTable))
                .syntax
                .with(\.trailingTrivia, .newlines(2))

            // let property: Type
            // ...
            MemberBlockItemListSyntax {
                for (name, type) in stringsTable.storedProperties {
                    VariableDeclSyntax(
                        .let,
                        name: PatternSyntax(IdentifierPatternSyntax(identifier: name)),
                        type: TypeAnnotationSyntax(type: type)
                    )
                }
            }
            .with(\.trailingTrivia, .newlines(2))

            // init(key: StaticString, ...) {
            //     self.key = key
            //     ...
            // }
            InitializerDeclSyntax(
                modifiers: [DeclModifierSyntax(name: .keyword(.fileprivate)),],
                signature: FunctionSignatureSyntax(
                    parameterClause: FunctionParameterClauseSyntax {
                        for (name, type) in stringsTable.storedProperties {
                            FunctionParameterSyntax(firstName: name, type: type)
                        }
                    }
                )
                .multiline()
            ) {
                for (name, _) in stringsTable.storedProperties {
                    InfixOperatorExprSyntax(
                        leftOperand: MemberAccessExprSyntax(.keyword(.`self`), name),
                        operator: AssignmentExprSyntax(),
                        rightOperand: DeclReferenceExprSyntax(baseName: name)
                    )
                }
            }
        }
    }

    var leadingTrivia: Trivia? {
        Trivia(docComment: stringsTable.headerDocumentation)
    }

    @DeclModifierListBuilder
    var modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: stringsTable.accessLevel.token)
    }
}
