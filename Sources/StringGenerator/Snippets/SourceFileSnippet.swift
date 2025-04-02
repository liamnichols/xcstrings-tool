import SwiftSyntax

struct SourceFileSnippet: Snippet {
    let sourceFile: SourceFile

    var syntax: SourceFileSyntax {
        SourceFileSyntax {
            ImportSnippet(module: .Foundation)

            ExtensionSnippet(extending: .type(.String)) {
                StringStringsTableStructSnippet(stringsTable: sourceFile.stringExtension.stringsTableStruct)
                StringInitializerSnippet(stringsTable: sourceFile.stringExtension.stringsTableStruct)
                StringsTableConversionStaticMethodSnippet(
                    stringsTable: sourceFile.stringExtension.stringsTableStruct,
                    returnType: .type(.String)
                )
            }

            ExtensionSnippet(
                availability: .wwdc2022,
                extending: .type(.LocalizedStringResource)
            ) {
                LocalizedStringResourceInitializerSnippet(
                    stringsTable: sourceFile.stringExtension.stringsTableStruct
                )

                StringsTableConversionStaticMethodSnippet(
                    stringsTable: sourceFile.stringExtension.stringsTableStruct,
                    returnType: .type(.LocalizedStringResource)
                )
            }

            IfCanImportSnippet(module: .SwiftUI) {
                ImportSnippet(module: .SwiftUI)
                    .syntax
                    .with(\.trailingTrivia, .newlines(2))

                ExtensionSnippet(
                    availability: .wwdc2019,
                    extending: .type(.Text)
                ) {
                    TextInitializerSnippet(
                        stringsTable: sourceFile.stringExtension.stringsTableStruct
                    )
                }
                .syntax
                .with(\.trailingTrivia, .newlines(2))

                ExtensionSnippet(
                    availability: .wwdc2019,
                    extending: .type(.LocalizedStringKey)
                ) {
                    LocalizedStringKeyInitializerSnippet(
                        stringsTable: sourceFile.stringExtension.stringsTableStruct
                    )

                    StringsTableConversionStaticMethodSnippet(
                        stringsTable: sourceFile.stringExtension.stringsTableStruct,
                        returnType: .type(.LocalizedStringKey),
                        availability: .wwdc2020
                    )

                    LocalizedStringKeyOverrideKeySnippet()
                }
            }
        }
        #if canImport(SwiftSyntax601)
        .spacingStatements(1)
        #else
        .spacingStatements()
        #endif
    }
}
