import Foundation
import StringResource
import SwiftBasicFormat
import SwiftIdentifier
import SwiftSyntax
import SwiftSyntaxBuilder

public struct StringGenerator {
    let sourceFile: SourceFile

    init(tableName: String, accessLevel: AccessLevel, resources: [Resource]) {
        self.sourceFile = SourceFile(tableName: tableName, accessLevel: accessLevel, resources: resources)
    }

    public static func generateSource(
        for resources: [Resource],
        tableName: String,
        accessLevel: AccessLevel
    ) -> String {
        StringGenerator(tableName: tableName, accessLevel: accessLevel, resources: resources)
            .generate()
            .formatted()
            .description
    }

    func generate() -> SourceFileSyntax {
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
                StringStringsTableArgumentValueComputedProperty()
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

//    func generateSwiftUI(
//        @CodeBlockItemListBuilder itemsBuilder: () throws -> CodeBlockItemListSyntax
//    ) rethrows -> some DeclSyntaxProtocol {
//        IfConfigDeclSyntax(
//            clauses: try IfConfigClauseListSyntax {
//                IfConfigClauseSyntax(
//                    poundKeyword: .poundIfToken(),
//                    condition: CanImportExprSyntax(importPath: .module(.SwiftUI)),
//                    elements: .statements(try itemsBuilder())
//                )
//            }
//        )
//    }
//
//    func generateSwiftUIImports() -> some DeclSyntaxProtocol {
//        ImportDeclSyntax(
//            path: [
//                ImportPathComponentSyntax(name: .module(.SwiftUI))
//            ]
//        )
//    }
//
//    func generateLocalizedStringKeyExtension() -> some DeclSyntaxProtocol {
//        ExtensionDeclSyntax(
//            availability: .wwdc2019,
//            extendedType: .identifier(.LocalizedStringKey)
//        ) {
//        }
//    }
}

extension String.LocalizationValue.Placeholder {
    var identifier: String {
        switch self {
        case .int: "Int"
        case .uint: "UInt"
        case .float: "Float"
        case .double: "Double"
        case .object: "String"
        @unknown default: "AnyObject"
        }
    }

    var caseName: TokenSyntax {
        switch self {
        case .int: "int"
        case .uint: "uint"
        case .float: "float"
        case .double: "double"
        case .object: "object"
        @unknown default: .identifier(String(describing: self))
        }
    }

    static let allCases: [Self] = [
        .int,
        .uint,
        .float,
        .double,
        .object
    ]
}
