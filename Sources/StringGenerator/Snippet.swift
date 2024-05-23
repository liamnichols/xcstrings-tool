import SwiftSyntax
import SwiftSyntaxBuilder

protocol Snippet<SyntaxType> {
    associatedtype SyntaxType: SyntaxProtocol

    var syntax: SyntaxType { get }
}

extension CodeBlockItemListBuilder {
    static func buildExpression(
        _ expression: some Snippet<some DeclSyntaxProtocol>
    ) -> CodeBlockItemListBuilder.Component {
        [CodeBlockItemSyntax(item: .decl(DeclSyntax(expression.syntax)))]
    }
}

extension CodeBlockItemListBuilder {
    static func buildExpression(
        _ expression: some Snippet<some StmtSyntaxProtocol>
    ) -> CodeBlockItemListBuilder.Component {
        [CodeBlockItemSyntax(item: .stmt(StmtSyntax(expression.syntax)))]
    }
}

extension MemberBlockItemListBuilder {
    static func buildExpression(
        _ expression: some Snippet<some DeclSyntaxProtocol>
    ) -> MemberBlockItemListBuilder.Component {
        [MemberBlockItemSyntax(decl: expression.syntax)]
    }
}
