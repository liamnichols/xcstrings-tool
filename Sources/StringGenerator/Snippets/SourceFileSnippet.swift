import SwiftSyntax

struct SourceFileSnippet: Snippet {
    let sourceFile: SourceFile

    var syntax: SourceFileSyntax {
        SourceFileSyntax {
            ImportSnippet(module: .Foundation)

            ExtensionSnippet(extending: .type(.String)) {
                StringStringsTableStructSnippet(stringsTable: sourceFile.stringExtension.stringsTableStruct)
                StringInitializerSnippet(stringsTable: sourceFile.stringExtension.stringsTableStruct)
            }

            ExtensionSnippet(extending: .type(.Bundle)) {
                ConvertBundleDescriptionMethodSnippet.toFoundationBundle(
                    from: sourceFile.stringExtension.stringsTableStruct.bundleDescriptionEnum
                )
            }

            ExtensionSnippet(
                availability: .wwdc2022,
                accessLevel: .private,
                extending: [.type(.LocalizedStringResource), .type(.BundleDescription)]
            ) {
                ConvertBundleDescriptionMethodSnippet.toLocalizedStringResourceBundleDescription(
                    from: sourceFile.stringExtension.stringsTableStruct.bundleDescriptionEnum
                )
            }

            ExtensionSnippet(
                availability: .wwdc2022,
                extending: .type(.LocalizedStringResource)
            ) {
                LocalizedStringResourceStringsTableStructSnippet(
                    stringsTable: sourceFile.localizedStringResourceExtension.stringsTableStruct
                )

                LocalizedStringResourceStringsTableComputedPropertySnippet(
                    sourceFile: sourceFile
                )

                LocalizedStringResourceInitializerSnippet(
                    stringsTable: sourceFile.stringExtension.stringsTableStruct
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
                    LocalizedStringKeyOverrideKeySnippet()
                }
            }
        }
        .spacingStatements()
    }
}
