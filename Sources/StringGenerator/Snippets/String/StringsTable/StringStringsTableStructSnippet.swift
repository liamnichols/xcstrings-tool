import SwiftSyntax
import SwiftSyntaxBuilder

/// The struct declaration that describes the strings table being generated
struct StringStringsTableStructSnippet: Snippet {
    let stringsTable: SourceFile.StringExtension.StringsTableStruct

    var syntax: some DeclSyntaxProtocol {
        // /// headerdoc
        // public struct Localizable { ... }
        StructDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: modifiers,
            name: stringsTable.type
        ) {
            // enum BundleDescription { ... }
            StringStringsTableBundleDescriptionEnumSnippet(bundleDescription: stringsTable.bundleDescriptionEnum)
                .syntax
                .with(\.trailingTrivia, .newlines(2))

            // enum Argument { ... }
            StringStringsTableArgumentEnumSnippet(argument: stringsTable.argumentEnum)
                .syntax
                .with(\.trailingTrivia, .newlines(2))

            // let property: Type
            // ...
            MemberBlockItemListSyntax {
                for property in stringsTable.storedProperties {
                    VariableDeclSyntax(
                        .let,
                        name: PatternSyntax(IdentifierPatternSyntax(identifier: property.name)),
                        type: TypeAnnotationSyntax(type: property.type)
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
                        for property in stringsTable.storedProperties {
                            FunctionParameterSyntax(firstName: property.name, type: property.type)
                        }
                    }
                )
                .multiline()
            ) {
                for property in stringsTable.storedProperties {
                    InfixOperatorExprSyntax(
                        leftOperand: MemberAccessExprSyntax(.keyword(.`self`), property.name),
                        operator: AssignmentExprSyntax(),
                        rightOperand: DeclReferenceExprSyntax(baseName: property.name)
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
