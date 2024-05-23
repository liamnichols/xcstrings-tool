import SwiftSyntax

extension SourceFileSyntax {
    func spacingStatements(_ lineCount: Int = 2) -> Self {
        var copy = self
        copy.statements = CodeBlockItemListSyntax {
            for (idx, item) in zip(1..., statements) {
                if idx == statements.count {
                    item
                } else {
                    item.with(\.trailingTrivia, .newlines(lineCount))
                }
            }
        }
        return copy
    }
}
