import SwiftSyntax

extension StructDeclSyntax {
    func spacingMembers(_ lineCount: Int = 2) -> StructDeclSyntax {
        updating(\.memberBlock) { memberBlock in
            memberBlock = memberBlock.spacingMembers(lineCount)
        }
    }
}
