import SwiftSyntax
import SwiftParser

extension String {
    var backtickedVariableNameIfNeeded: String {
        // In SwiftSyntax 600, use isValidIdentifier(for:)
        // https://github.com/apple/swift-syntax/pull/2434
        // Thanks @ahoppen!
        _isValidVariableName ? self : "`\(self)`"
    }

    private var _isValidVariableName: Bool {
#if canImport(SwiftSyntax600)
        isValidSwiftIdentifier(for: .variableName)
#else
        let name = self

        var parser = Parser("var \(name)")
        let decl = DeclSyntax.parse(from: &parser)

        guard !decl.hasError && !decl.hasWarning else {
            // There were syntax errors in the source code. So not valid.
            return false
        }

        guard let variable = decl.as(VariableDeclSyntax.self) else {
            return false
        }

        guard let identifier = variable.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier else {
            return false
        }

        guard case .identifier = identifier.tokenKind else {
            // We parsed the name as a keyword, eg. `self`, so not a valid identifier.
            return false
        }

        guard identifier.text.count == name.utf8.count else {
            // The identifier doesn't cover all the characters in `name`, so we parsed
            // some of these characters into trivia or another token.
            // Thus, `name` is not a valid identifier.
            return false
        }

        return true
#endif
    }
}
