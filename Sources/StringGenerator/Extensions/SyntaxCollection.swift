import SwiftSyntax

extension SyntaxCollection {
    public func map(
        _ transform: (Element) throws -> Element
    ) rethrows -> Self {
        Self(try map(transform) as [Element])
    }
}
