import Foundation
import StringResource
import SwiftIdentifier
import SwiftSyntax

/// A model that describes the overall source file to be generated
struct SourceFile {
    /// The raw name of the strings table that the ``SourceFile`` is being generated for
    let tableName: String

    /// The access level to be used when generating non-private interfaces
    let accessLevel: AccessLevel
    
    /// Option to convert resource identifiers from snake case
    let convertFromSnakeCase: Bool

    /// Supporting SE0409
    let importsUseExplicitAccessLevel: Bool

    /// The string resources that make up the strings table
    let resources: [Resource]
}

extension SourceFile {
    var tableTypeIdentifier: String {
        SwiftIdentifier.identifier(from: tableName)
    }

    var tableVariableIdentifier: String {
        SwiftIdentifier.variableIdentifier(for: tableName)
    }
}
