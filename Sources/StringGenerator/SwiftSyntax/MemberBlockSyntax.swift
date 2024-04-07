import SwiftSyntax

extension MemberBlockSyntax {
    func spacingMembers(_ lineCount: Int = 2) -> MemberBlockSyntax {
        updating(\.members) { members in
            members = MemberBlockItemListSyntax {
                for (idx, item) in zip(1..., members) {
                    if idx == members.count {
                        item
                    } else {
                        item.with(\.trailingTrivia, .newlines(lineCount))
                    }
                }
            }
        }
    }
}
