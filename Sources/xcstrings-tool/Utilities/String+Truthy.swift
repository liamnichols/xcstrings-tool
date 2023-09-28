import Foundation

extension String {
    var isTruthy: Bool {
        ["YES", "TRUE", "1"].contains(self.uppercased())
    }
}
