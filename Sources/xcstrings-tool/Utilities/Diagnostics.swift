import Foundation

struct Diagnostic: CustomStringConvertible {
    enum Severity {
        case error, warning, note
    }

    var severity: Severity
    var sourceFile: URL?
    var message: String

    var description: String {
        var output: String = ""
        
        if let sourceFile {
            output += sourceFile.absoluteURL.path(percentEncoded: false) + ":"
            output += " "
        }

        output += {
            switch severity {
            case .error: "error: "
            case .warning: "warning: "
            case .note: "note: "
            }
        }()

        output += message

        return output
    }
}

// MARK: - Error Type
extension Diagnostic: LocalizedError {
    var errorDescription: String? {
        description
    }
}

// MARK: - Globals

/// Catch thrown errors and convert them to an error diagnostic
@discardableResult
func withThrownErrorsAsDiagnostics<T>(
    at sourceFile: URL? = nil,
    _ throwingWork: () throws -> T
) throws -> T {
    do {
        return try throwingWork()
    } catch let error as Diagnostic {
        throw error
    } catch let error as DecodingError {
        throw Diagnostic(
            severity: .error,
            sourceFile: sourceFile,
            message: String(reflecting: error) // Use CustomStringDebugConvertible
        )
    } catch {
        throw Diagnostic(
            severity: .error,
            sourceFile: sourceFile,
            message: error.localizedDescription
        )
    }
}

struct Logger: Sendable {
    var isVerboseLoggingEnabled = false

    /// Log a diagnostic with the note severity only when in verbose mode
    func debug(_ message: @autoclosure () -> String, sourceFile: URL? = nil) {
        guard isVerboseLoggingEnabled else { return }
        note(message(), sourceFile: sourceFile)
    }

    /// Log a diagnostic with the note severity
    func note(_ message: String, sourceFile: URL? = nil) {
        log(.note, message, sourceFile: sourceFile)
    }

    /// Log a diagnostic with the warning severity
    func warning(_ message: String, sourceFile: URL? = nil) {
        log(.warning, message, sourceFile: sourceFile)
    }

    /// Log a diagnostic with the error severity
    func error(_ message: String, sourceFile: URL? = nil) {
        log(.error, message, sourceFile: sourceFile)
    }

    func log(_ severity: Diagnostic.Severity, _ message: String, sourceFile: URL? = nil) {
        print(
            Diagnostic(
                severity: severity,
                sourceFile: sourceFile,
                message: message
            )
        )
    }
}

// MARK: - Better Errors
#if compiler(>=6.0)
extension DecodingError: @retroactive CustomDebugStringConvertible {
    public var debugDescription: String { _debugDescription }
}
#else
extension DecodingError: CustomDebugStringConvertible {
    public var debugDescription: String { _debugDescription }
}
#endif

private extension DecodingError {
    var _debugDescription: String {
        guard let context else { return localizedDescription }

        if context.codingPath.isEmpty {
            return context.debugDescription
        }

        let codingPath = context.codingPath
            .map { $0.intValue.flatMap({ "[\($0.description)]" }) ?? $0.stringValue }
            .joined(separator: " → ")

        return "Decoding error at ‘\(codingPath)‘ - \(localizedDescription)"
    }

    var context: Context? {
        switch self {
        case .typeMismatch(_, let context),
                .valueNotFound(_, let context),
                .keyNotFound(_, let context),
                .dataCorrupted(let context):
            context
        @unknown default:
            nil
        }
    }
}
