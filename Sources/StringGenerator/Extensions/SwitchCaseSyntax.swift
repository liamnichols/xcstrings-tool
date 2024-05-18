import SwiftSyntax
import SwiftSyntaxBuilder

extension SwitchCaseSyntax {
    init(
        singleCasePattern: ExpressionPatternSyntax,
        @CodeBlockItemListBuilder statementsBuilder: () -> CodeBlockItemListSyntax
    ) {
        self.init(
            label: .case(
                SwitchCaseLabelSyntax {
                    SwitchCaseItemSyntax(
                        pattern: singleCasePattern
                    )
                }
            ),
            statements: statementsBuilder()
        )
    }
}
