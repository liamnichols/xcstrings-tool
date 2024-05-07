import SwiftSyntax

extension ArrayExprSyntax {
    func multiline() -> ArrayExprSyntax {
        if elements.isEmpty {
            self
        } else {
            updating(\.elements) { elements in
                elements = ArrayElementListSyntax {
                    for element in elements {
                        element.with(\.leadingTrivia, .newline)
                    }
                }
            }
            .with(\.rightSquare, .rightSquareToken(leadingTrivia: .newline))
        }
    }
}
