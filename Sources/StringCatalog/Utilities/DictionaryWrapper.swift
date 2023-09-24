import Foundation

// Workaround for https://forums.swift.org/t/using-rawrepresentable-string-and-int-keys-for-codable-dictionaries/26899
// Cannot be a property wrapper due to https://forums.swift.org/t/using-property-wrappers-with-codable/29804
// Assumes `Key.RawValue.init(rawValue:)` is non-failable
public struct DictionaryWrapper<Key: Hashable & RawRepresentable, Value> where Key.RawValue: Hashable {
    public typealias WrappedValue = Dictionary<Key.RawValue, Value>

    public var wrappedValue: WrappedValue

    public init(wrappedValue: WrappedValue) {
        self.wrappedValue = wrappedValue
    }
}

// MARK: - Subscripting
extension DictionaryWrapper {
    public subscript(_ key: Key) -> Value? {
        get {
            wrappedValue[key.rawValue]
        }
        mutating set {
            wrappedValue[key.rawValue] = newValue
        }
    }

    public subscript(key: Key, default defaultValue: @autoclosure () -> Value) -> Value {
        get {
            wrappedValue[key.rawValue, default: defaultValue()]
        }
        mutating set {
            wrappedValue[key.rawValue] = newValue
        }
    }
}

// MARK: - ExpressibleByDictionaryLiteral
extension DictionaryWrapper: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(
            wrappedValue: Dictionary(
                uniqueKeysWithValues: elements.map { ($0.0.rawValue, $0.1) }
            )
        )
    }
}

// MARK: - Codable
// MARK: Decodable
extension DictionaryWrapper: Decodable where Key.RawValue: Decodable, Value: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(wrappedValue: try container.decode(WrappedValue.self))
    }
}

// MARK: Encodable
extension DictionaryWrapper: Encodable where Key.RawValue: Encodable, Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

// MARK: - Equatable
extension DictionaryWrapper: Equatable where Self.WrappedValue: Equatable {
}

// MARK: - Hashable
extension DictionaryWrapper: Hashable where Self.WrappedValue: Hashable {
}

// MARK: - Sequence
extension DictionaryWrapper: Sequence {
    public typealias Element = (key: Key, value: Value)

    public struct Iterator: IteratorProtocol {
        public var base: WrappedValue.Iterator

        public mutating func next() -> DictionaryWrapper<Key, Value>.Element? {
            if let next = base.next() {
                return (key: Key(rawValue: next.key)!, value: next.value)
            } else {
                return nil
            }
        }
    }

    public func makeIterator() -> Iterator {
        Iterator(base: wrappedValue.makeIterator())
    }
}

// MARK: - Values
extension DictionaryWrapper {
    public typealias Values = WrappedValue.Values

    public var values: Values {
        wrappedValue.values
    }
}
