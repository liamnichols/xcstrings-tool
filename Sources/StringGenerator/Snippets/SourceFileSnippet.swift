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

            ExtensionSnippet(extending: sourceFile.stringExtension.stringsTableStruct.fullyQualifiedType) {
                for accessor in sourceFile.stringExtension.stringsTableStruct.accessors {
                    if accessor.hasArguments {
                        StringStringsTableResourceFunctionSnippet(accessor: accessor)
                    } else {
                        StringStringsTableResourceVariableSnippet(accessor: accessor)
                    }
                }
            }

            ExtensionSnippet(
                availability: .wwdc2021,
                accessLevel: .private,
                extending: sourceFile.stringExtension.stringsTableStruct.fullyQualifiedType
            ) {
                StringStringsTableDefaultValueComputedPropertySnippet()
            }

            ExtensionSnippet(
                extending: sourceFile.stringExtension.stringsTableStruct.argumentEnum.fullyQualifiedType
            ) {
                StringStringsTableArgumentValueComputedProperty(
                    argumentEnum: sourceFile.stringExtension.stringsTableStruct.argumentEnum
                )
            }

            ExtensionSnippet(
                accessLevel: .private,
                extending: sourceFile.stringExtension.stringsTableStruct.bundleDescriptionEnum.fullyQualifiedType
            ) {
                IfConfigDeclSyntax(
                    prefixOperator: "!",
                    reference: "SWIFT_PACKAGE",
                    elements: .decls(MemberBlockItemListSyntax {
                        StringStringsTableBundleLocatorClassSnippet()
                    })
                )

                StringStringsTableBundleDescriptionCurrentComputedPropertySnippet()
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

                LocalizedStringResourceInitializerSnippet(
                    stringsTable: sourceFile.stringExtension.stringsTableStruct
                )

                LocalizedStringResourceStringsTableComputedPropertySnippet(
                    sourceFile: sourceFile
                )
            }
        }
        .spacingStatements()
    }
}
