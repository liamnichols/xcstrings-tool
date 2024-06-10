import SwiftSyntax

public extension SyntaxProtocol {
    /// Returns a new syntax node that has the child at `keyPath` updated by the changes closure
    func updating<T>(_ keyPath: WritableKeyPath<Self, T>, changes: (inout T) -> Void) -> Self {
        var copy = self
        changes(&copy[keyPath: keyPath])
        return copy
    }

    /// Returns a new syntax node that has the child at `keyPath` replaced by
    /// `value` if the given condition is met
    func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T, if condition: Bool) -> Self {
        guard condition else { return self }
        return with(keyPath, value)
    }
}
