import SwiftSyntax

extension Trivia {
    init(docComment: String) {
        self = docComment
            .components(separatedBy: .newlines)
            .map { "/// \($0)" }
            .map { [.docLineComment($0.trimmingCharacters(in: .whitespaces)), .newlines(1)] }
            .reduce([], +)
    }
}
