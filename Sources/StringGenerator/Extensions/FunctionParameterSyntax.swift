import StringResource
import SwiftSyntax

extension FunctionParameterSyntax {
    init(argument: Argument) {
        self.init(
            firstName: argument.label.flatMap { .identifier($0) } ?? .wildcardToken(),
            secondName: .identifier(argument.name),
            type: IdentifierTypeSyntax(name: .identifier(argument.placeholderType.identifier))
        )
    }
}
